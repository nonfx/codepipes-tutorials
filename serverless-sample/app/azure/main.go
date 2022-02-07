package main

import (
	"bytes"
	"fmt"
	"log"
	"os"

	azi "github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/storage/azblob"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/template/html"
)

const (
	containerName = "artifacts"
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
	item := os.Getenv("IMAGE_PATH")
	client := GetBlobClient(item)
	downloadedData := &bytes.Buffer{}
	get, err := client.Download(c.Context(), &azblob.DownloadBlobOptions{})
	if err != nil {
		log.Printf("failed to download file ,%v", err)
		return err
	}

	reader := get.Body(azblob.RetryReaderOptions{})
	defer reader.Close()
	_, err = downloadedData.ReadFrom(reader)
	if err != nil {
		log.Printf("failed to read downloaded content ,%v", err)
		return err
	}
	return c.Status(200).Send(downloadedData.Bytes())
}

func GetBlobClient(path string) azblob.BlockBlobClient {
	tenantId := os.Getenv("AZURE_TENANT_ID")
	clientId := os.Getenv("AZURE_CLIENT_ID")
	clientSecret := os.Getenv("AZURE_CLIENT_SECRET")
	cred, err := azi.NewClientSecretCredential(tenantId, clientId, clientSecret, nil)
	if err != nil {
		log.Printf("Couldn't get file, %v", err)
	}
	blobServiceUrl := fmt.Sprintf("https://%s.blob.core.windows.net/", os.Getenv("STORAGE_ACCOUNT_NAME"))
	service, err := azblob.NewServiceClient(blobServiceUrl, cred, nil)
	if err != nil {
		log.Printf("Couldn't get azure blob client, %v", err)
	}
	return service.NewContainerClient(containerName).NewBlockBlobClient(path)
}
