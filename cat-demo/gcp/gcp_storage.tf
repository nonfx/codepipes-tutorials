resource "google_storage_bucket" "website_bucket" {
  provider = google-beta
  name = "hello-vang-${random_string.random.result}-${replace(lower(var.what_to_say)," ","-")}"
  force_destroy = true
  project = var.GOOGLE_PROJECT

  website {
    main_page_suffix = "index.html"
    not_found_page = "index.html"
  }
}

resource "google_storage_bucket_acl" "website_bucket_acl" {
  provider = google-beta
  bucket = google_storage_bucket.website_bucket.name
  role_entity = ["READER:allUsers"]
}

resource "local_file" "index_html_gcp" {
    content     = templatefile("${path.module}/index.html.tmpl", {orgname = var.orgname, what_to_say = replace(var.what_to_say, " ", "%20")})
    filename = "${path.module}/index.html"
}

resource "google_storage_bucket_object" "object" {
  bucket = google_storage_bucket.website_bucket.name
  name    = "index.html"
  source = "${path.module}/index.html"
  content_type = "text/html"
}

resource "google_storage_object_access_control" "public_rule" {
  object = google_storage_bucket_object.object.output_name
  bucket = google_storage_bucket.website_bucket.name
  role   = "READER"
  entity = "allUsers"
}
