package main

import (
	"context"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"
	"sync"

	"cloud.google.com/go/storage"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/template/html"
)

var (
	bucketHandle *storage.BucketHandle
	gifFilePath  = os.Getenv("IMAGE_PATH")
	once         sync.Once
)

func init() {
	ctx := context.Background()
	GCSClient, err := GetGCSClient(ctx)
	if err != nil {
		log.Printf("Couldn't get storage client, %v", err)
		os.Exit(0)
	}

	bucketStr := os.Getenv("BUCKET_NAME")
	bucketStr = strings.TrimLeft(bucketStr, "[")
	bucketStr = strings.TrimRight(bucketStr, "]")
	fmt.Printf("BUCKET %s", bucketStr)

	ProjectID := os.Getenv("PROJECT_ID")
	bucketHandle = GCSClient.Bucket(bucketStr).UserProject(ProjectID)
	fmt.Printf("bucket handle acquired with %s %s", bucketStr, ProjectID)
	// Load initial data
	// storage image upload
	wc := bucketHandle.Object(gifFilePath).NewWriter(ctx)
	wc.ContentType = "image/gif"
	boratGIF, err := os.Open(gifFilePath)
	if err != nil {
		log.Printf("Couldn't open borat gif file, %v", err)
		os.Exit(0)
	}
	boratGIFBytes, err := ioutil.ReadAll(boratGIF)
	if err != nil {
		log.Printf("Couldn't read buffered data, %v", err)
		os.Exit(0)
	}
	if _, err := wc.Write(boratGIFBytes); err != nil {
		log.Printf("createFile: unable to write data to bucket %q, file %q: %v", bucketStr, gifFilePath, err)
		return
	}

	if err := wc.Close(); err != nil {
		log.Printf("createFile: unable to close bucket %q, file %q: %v", bucketStr, gifFilePath, err)
		return
	}

}

func main() {
	engine := html.New("./views", ".html")
	app := fiber.New(fiber.Config{
		Views: engine,
	})
	app.Use(logger.New())
	app.Get("/", func(c *fiber.Ctx) error {
		// Render index template
		return c.Render("index", fiber.Map{
			"path": "/gif",
		})
	})
	app.Get("/gif", getStorageFile)
	app.Listen(fmt.Sprintf(":%d", 8080))
}

func getStorageFile(c *fiber.Ctx) error {
	clientCtx := c.Context()
	reader, err := bucketHandle.Object(gifFilePath).NewReader(clientCtx)
	if err != nil {
		log.Printf("Couldn't get bucket, %v", err)
		return fiber.NewError(fiber.StatusServiceUnavailable, "Storage bucket not configured")
	}
	defer reader.Close()
	content, err := ioutil.ReadAll(reader)
	if err != nil {
		log.Printf("Couldn't get file, %v", err)
		return fiber.NewError(fiber.StatusServiceUnavailable, "could not parse the image")
	}
	return c.Status(200).Send(content)
}

// GetGCSClient gets singleton object for Google Storage
// Set ENV variable export GOOGLE_APPLICATION_CREDENTIALS="[PATH]"
func GetGCSClient(ctx context.Context) (storageClient *storage.Client, clientErr error) {
	var err error
	once.Do(func() {
		storageClient, err = storage.NewClient(ctx)
		if err != nil {
			clientErr = fmt.Errorf("failed to create gcs client:%s", err.Error())
		}

	})
	return storageClient, nil
}
