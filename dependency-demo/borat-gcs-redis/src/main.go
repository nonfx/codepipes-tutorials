package main

import (
	"context"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sync"

	"cloud.google.com/go/storage"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/template/html"
	"github.com/gomodule/redigo/redis"
)

var (
	bucketHandle *storage.BucketHandle
	redisPool    *redis.Pool

	gifFilePath = os.Getenv("IMAGE_PATH")
	once        sync.Once
)

func init() {
	ctx := context.Background()
	GCSClient, err := GetGCSClient(ctx)
	if err != nil {
		log.Printf("Couldn't get storage client, %v", err)
		os.Exit(0)
	}
	redisPool = getCacheClient()
	bucketName := os.Getenv("BUCKET_NAME")

	ProjectID := os.Getenv("PROJECT_ID")
	bucketHandle = GCSClient.Bucket(bucketName).UserProject(ProjectID)
	fmt.Printf("bucket handle acquired with %s %s", bucketName, ProjectID)
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
		log.Printf("createFile: unable to write data to bucket %q, file %q: %v", bucketName, gifFilePath, err)
		return
	}

	if err := wc.Close(); err != nil {
		log.Printf("createFile: unable to close bucket %q, file %q: %v", bucketName, gifFilePath, err)
		return
	}
	fmt.Printf("Borat gif uploaded")
}

func main() {
	engine := html.New("./views", ".html")
	app := fiber.New(fiber.Config{
		Views: engine,
	})
	app.Use(logger.New())
	app.Get("/", func(c *fiber.Ctx) error {
		// increment visitor count
		vc := incrementVisitorCount()
		// Render index template
		return c.Render("index", fiber.Map{
			"path":        "/gif",
			"vistorCount": vc,
		})
	})
	app.Get("/gif", getStorageFile)
	app.Get("/cache", getStorageFile)
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

func getCacheClient() *redis.Pool {
	redisHost := os.Getenv("REDISHOST")
	redisPort := os.Getenv("REDISPORT")
	redisAddr := fmt.Sprintf("%s:%s", redisHost, redisPort)
	fmt.Printf("redisAddr %s", redisAddr)
	const maxConnections = 10

	return &redis.Pool{
		MaxIdle: maxConnections,
		Dial: func() (redis.Conn, error) {
			return redis.Dial("tcp", redisAddr)
		},
	}

}

func incrementVisitorCount() int {
	conn := redisPool.Get()
	defer conn.Close()

	counter, err := redis.Int(conn.Do("INCR", "visits"))
	if err != nil {
		log.Printf("Error incrementing visitor counter %v", err)
		return 0
	}
	fmt.Printf("Visitor number: %d", counter)
	return counter
}
