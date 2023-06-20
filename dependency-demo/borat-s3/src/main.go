package main

import (
	"bytes"
	_ "embed"
	"fmt"
	"html/template"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
)

var (
	//go:embed views/index.html
	indexFormat string

	indexTmpl *template.Template

	s3Client *s3.S3

	region = "us-east-1"
	bucket = "bucket-name"
	key    = "test.gif"
)

func init() {
	// region = os.Getenv("bucket_region")
	bucket = os.Getenv("bucket_name")
	var err error
	indexTmpl, err = template.New("index").Parse(indexFormat)
	if err != nil {
		panic(fmt.Sprintf("error parsing index template: %v", err))
	}
}

func main() {
	// AWS S3 configuration

	// Create an AWS session
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)
	if err != nil {
		log.Fatal(err)
	}

	// Create an S3 service client
	s3Client = s3.New(sess)

	file, err := os.Open(key)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	uploader := s3manager.NewUploader(sess)
	_, err = uploader.Upload(&s3manager.UploadInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
		Body:   file,
	})
	if err != nil {
		log.Fatal(err)
	}

	// HTTP handler function
	http.HandleFunc("/", FileHandler)
	http.HandleFunc("/gif", GetBucketObject)

	// Start the server
	port := "8080"
	log.Printf("Server started on port %s\n", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}

func FileHandler(w http.ResponseWriter, r *http.Request) {

	res := map[string]interface{}{"path": "/gif"}

	writer := bytes.NewBufferString("")
	err := indexTmpl.Execute(writer, res)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
	}
	w.Write(writer.Bytes())
	w.WriteHeader(http.StatusOK)
}

func GetBucketObject(w http.ResponseWriter, r *http.Request) {
	// Get the GIF file from S3
	resp, err := s3Client.GetObject(&s3.GetObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
	})
	if err != nil {
		log.Println("Failed to retrieve GIF file:", err)
		http.Error(w, "Failed to retrieve GIF file", http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close()

	// Read the contents of the response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Println("Failed to read response body:", err)
		http.Error(w, "Failed to read response body", http.StatusInternalServerError)
		return
	}
	w.Write(body)
	w.WriteHeader(http.StatusOK)
}
