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

type storageConnection struct {
	Client *storage.Client
}

var (
	client    *storageConnection
	once      sync.Once
	redisPool *redis.Pool
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
	GCSBucket := os.Getenv("BUCKET")
	ProjectID := os.Getenv("PROJECT_ID")
	filePath := os.Getenv("IMAGE_PATH")
	clientCtx := c.Context()
	client, err := GetGCSClient(clientCtx)
	if err != nil {
		log.Printf("Couldn't get client, %v", err)
	}
	reader, err := client.Bucket(GCSBucket).UserProject(ProjectID).Object(filePath).NewReader(clientCtx)
	if err != nil {
		log.Printf("Couldn't get bucket, %v", err)
	}
	defer reader.Close()
	content, err := ioutil.ReadAll(reader)
	if err != nil {
		log.Printf("Couldn't get file, %v", err)
	}
	return c.Status(200).Send(content)
}

func getVisitorNumber(c *fiber.Ctx) error {
	incrementHandler()
	return c.Status(200).Send(content)
}

// GetGCSClient gets singleton object for Google Storage
// Set ENV variable export GOOGLE_APPLICATION_CREDENTIALS="[PATH]"
func GetGCSClient(ctx context.Context) (*storage.Client, error) {
	var clientErr error
	once.Do(func() {
		storageClient, err := storage.NewClient(ctx)
		if err != nil {
			clientErr = fmt.Errorf("Failed to create GCS client ERROR:%s", err.Error())
		} else {
			client = &storageConnection{
				Client: storageClient,
			}
		}
	})
	return client.Client, clientErr
}

func getConnection() (*redis.Pool, error) {
	redisHost := os.Getenv("REDISHOST")
	redisPort := os.Getenv("REDISPORT")
	redisAddr := fmt.Sprintf("%s:%s", redisHost, redisPort)

	const maxConnections = 10
	redisPool = &redis.Pool{
		MaxIdle: maxConnections,
		Dial:    func() (redis.Conn, error) { return redis.Dial("tcp", redisAddr) },
	}
	return redisPool, nil
}

func incrementHandler() error {
	conn := redisPool.Get()
	defer conn.Close()

	counter, err := redis.Int(conn.Do("INCR", "visits"))
	if err != nil {

		return err
	}
	return nil
}

func getCounter() error {
	conn := redisPool.Get()
	defer conn.Close()

	counter, err := redis.Int(conn.Do("INCR", "visits"))
	if err != nil {

		return err
	}
	return nil
}
