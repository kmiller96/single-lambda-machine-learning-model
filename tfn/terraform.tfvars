## Global Values ##
resource_name_prefix = "adss-single-model-"

## IAM Configuration ##
iam_role_name = "lambda-iam"

## S3 Configuration ##
bucket_name = "adss-single-lambda-terraform"
source_key_prefix = "source"

## Training Lambda ##
training_lambda_name = "training"
training_lambda_handler = "app.train"
training_lambda_memory = 128
training_lambda_timeout_seconds = 300

## Inference Lambda ##
inference_lambda_name = "inference"
inference_lambda_handler = "app.predict"
inference_lambda_memory = 128
inference_lambda_timeout_seconds = 300