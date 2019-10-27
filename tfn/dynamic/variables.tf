variable "resource_name_prefix" {
    type = string 
}


variable "bucket_name" {
    type = string
}
variable "source_key_prefix" {
    type = string
}


variable "iam_role_name" {
    type = string
}


variable "training_lambda_name" {
    type = string 
}
variable "training_lambda_handler" {
    type = string
}
variable "training_lambda_memory" {
    type = number
}
variable "training_lambda_timeout_seconds" {
    type = number
}

variable "inference_lambda_name" {
    type = string 
}
variable "inference_lambda_handler" {
    type = string
}
variable "inference_lambda_memory" {
    type = number
}
variable "inference_lambda_timeout_seconds" {
    type = number
}