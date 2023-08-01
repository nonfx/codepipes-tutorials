#Common Variables
variable "lb_listener_arn" {
  description = "The ARN of the Load Balancer Listener"
  type        = string
}

#Listener Rule Variables
variable "path" {
  description = "The path pattern for the listener rule"
  type        = list(string)
  default     = null
}

variable "site" {
  description = "The host header for the listener rule"
  type        = list(string)
  default     = null
}

variable "target_group_arn" {
  description = "The ARN of the target group"
  type        = string
}

variable "number" {
  description = "Increment count for priority"
  type        = number
}
