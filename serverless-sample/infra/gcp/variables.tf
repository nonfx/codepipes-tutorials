variable "GOOGLE_PROJECT" {
description = "Google Project ID."
type        = string
}

variable "BUCKET_LOCATION" {
description = "The geographic location of the storage bucket (US, EU, ASIA)."
type        = string
default     = "US"
}
