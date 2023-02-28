variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "redis_node_type" {
    type = string
    default = "cache.t2.small"
}

variable "redis_version" {
    type = string
    default = "7.0"
}

# The param group name should change with the redis_version
variable "redis_param_group" {
    type = string
    default = "default.redis7"
}

variable "redis_port" {
    type = number
    default = 6379
}