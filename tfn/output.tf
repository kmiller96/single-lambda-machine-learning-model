output "bucket_id" {
    value = aws_s3_bucket.this.id
}

output "training_lambda_arn" {
    value = aws_lambda_function.training_lambda.arn
}
output "inference_lambda_arn" {
    value = aws_lambda_function.inference_lambda.arn
}