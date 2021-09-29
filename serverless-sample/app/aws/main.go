package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sync"

	"cloud.google.com/go/storage"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/template/html"
)

type storageConnection struct {
	Client *storage.Client
}

var (
	client *storageConnection
	once   sync.Once
)

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
	client, err := GetS3Client()
	if err != nil {
		log.Printf("failed to create S3 client error:, %v", err)
	}
	bucket := os.Getenv("BUCKET")
	item := os.Getenv("IMAGE_PATH")
	// 3) Create a new AWS S3 downloader
	downloader := s3manager.NewDownloader(client)

	// 4) Download the item from the bucket. If an error occurs, log it and exit. Otherwise, notify the user that the download succeeded.
	file, err := os.Create(item)
	if err != nil {
		log.Printf("failed to create file c,%v", err)
	}
	_, err = downloader.Download(file,
		&s3.GetObjectInput{
			Bucket: aws.String(bucket),
			Key:    aws.String(item),
		})

	if err != nil {
		log.Fatalf("Unable to download item %q, %v", item, err)
	}

	content, err := ioutil.ReadAll(file)
	if err != nil {
		log.Printf("Couldn't get file, %v", err)
	}
	return c.Status(200).Send(content)
}

func GetS3Client() (*session.Session, error) {
	region := os.Getenv("REGION")
	return session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)
}
