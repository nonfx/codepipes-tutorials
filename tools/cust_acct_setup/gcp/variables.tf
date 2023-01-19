variable "project" {
  description = "The ID of the project to configure."
  type        = string
}

variable "service_account_name" {
  description = "The name of the target GCP service account to create"
  type        = string
}

variable "bucket_name" {
  description = "The name of the GCS bucket to be used for storing Code Pipes pipeline artifacts"
  type        = string
}

variable "bucket_region" {
  description = "The GCP region where the bucket should be stored"
  type        = string
  default     = "US"
}

variable "key_ring" {
  description = "The KMS key ring to be used"
  type        = string
  default     = "codepipes-keys"
}

variable "cloud_build_topic_name" {
  description = "The Pub/Sub topic name for Cloud Build"
  type        = string
  default     = "cloud-builds"
}

variable "cloud_build_subscription_name" {
  description = "The name of the subscription for the Cloud Build listener"
  type = string
  default = "codepipes.events.pipeline-listener" 
}

variable "iam_pipeline_role_name" {
  description = "The name for the IAM role created for Cloud Build execution"
  type = string
  default = "CodePipesPipelineRole"
}

variable "iam_creator_role_name" {
  description = "The name for the IAM role created to allow Code Pipes to create resources"
  type = string
  default = "CodePipesResourceCreatorRole"
}

variable "iam_cloudrun_role_name" {
  description = "The name for the IAM role created for use by Cloud Run"
  type = string
  default = "CodePipesCloudRunRole"
}

variable "with_gke" {
  description = "Configure GKE services for project"
  type        = bool
  default     = false
}

variable "with_cloudrun" {
  description = "Configure CloudRun services for project"
  type        = bool
  default     = false
}

# These are really constants - just wanted them centrally defined
variable "api_services" {
  type = list(string)
  default = [
    "compute.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudkms.googleapis.com",
    "pubsub.googleapis.com",
  ]
}

variable "cloudrun_services" {
  type = list(string)
  default = [
    "secretmanager.googleapis.com",
    "run.googleapis.com"
  ]
}

variable "gke_services" {
  type = list(string)
  default = [
    "container.googleapis.com"
  ]
}
