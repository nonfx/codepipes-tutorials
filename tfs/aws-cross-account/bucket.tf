resource "random_pet" "bucket_suffix" {
  length = 2  # Adjust the length of the random suffix if desired
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-${random_pet.bucket_suffix.id}"
}


resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl = "private"  # Adjust the ACL if desired
}