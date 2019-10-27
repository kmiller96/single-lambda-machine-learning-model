
provider "aws" {
    profile = "default"
    region = "ap-southeast-2"
}

locals {
    lambda_runtime = "python3.7"
}

#############
## BUCKETS ##
#############

resource "aws_s3_bucket" "this" {
    bucket = var.bucket_name
    acl = "private"
}

###############
## IAM ROLES ##
###############

resource "aws_iam_role_policy" "single_bucket_full_access" {
  name = "test_policy"
  role = "${aws_iam_role.lambda_iam.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_role" "lambda_iam" {
    name = "${var.resource_name_prefix}${var.iam_role_name}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
    EOF
}

#############
## LAMBDAS ##
#############

resource "aws_lambda_function" "training_lambda" {
    function_name = "${var.resource_name_prefix}${var.training_lambda_name}"
    role = "${aws_iam_role.lambda_iam.arn}"
    handler = var.training_lambda_handler

    memory_size = var.training_lambda_memory
    runtime = local.lambda_runtime
    timeout = var.training_lambda_timeout_seconds

    s3_bucket = var.bucket_name
    s3_key = "${var.source_key_prefix}/training.zip"

}


resource "aws_lambda_function" "inference_lambda" {
    function_name = "${var.resource_name_prefix}${var.inference_lambda_name}"
    role = "${aws_iam_role.lambda_iam.arn}"
    handler = var.inference_lambda_handler

    memory_size = var.inference_lambda_memory
    runtime = local.lambda_runtime
    timeout = var.inference_lambda_timeout_seconds

    s3_bucket = var.bucket_name
    s3_key = "${var.source_key_prefix}/inference.zip"
}


resource "aws_lambda_permission" "allow_bucket_training" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.training_lambda.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.this.arn}"
}

resource "aws_lambda_permission" "allow_bucket_inference" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.inference_lambda.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.this.arn}"
}

##############################
## CLOUDWATCH NOTIFICATIONS ##
##############################

resource "aws_s3_bucket_notification" "triggers" {
  bucket = "${aws_s3_bucket.this.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.training_lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "train/"
  }

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.inference_lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "predict/"
  }
}
