
# ---------------------------------------------------------
# S3 Bucket to Store Lambda Code ZIP
# ---------------------------------------------------------
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "my-demo-lambda-bucket-5thnov"  # Must be globally unique
}

# ---------------------------------------------------------
# IAM Role for Lambda
# ---------------------------------------------------------
resource "aws_iam_role" "lambda_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Allow Lambda to Write CloudWatch Logs
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow Lambda to Read from S3
resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# ---------------------------------------------------------
# CloudWatch Log Group for Lambda
# ---------------------------------------------------------
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/s3lambda-function"
  retention_in_days = 30
}

# ---------------------------------------------------------
# Automatically ZIP Lambda Code
# ---------------------------------------------------------
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

# ---------------------------------------------------------
# Upload ZIP to S3
# ---------------------------------------------------------
resource "aws_s3_object" "lambda_upload" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "lambda_function.zip"
  source = data.archive_file.lambda_zip.output_path
  etag   = data.archive_file.lambda_zip.output_md5
}

# ---------------------------------------------------------
# Lambda Function (Code Loaded from S3)
# ---------------------------------------------------------
resource "aws_lambda_function" "my_lambda" {
  function_name = "s3lambda-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128

  s3_bucket = aws_s3_bucket.lambda_bucket.bucket
  s3_key    = aws_s3_object.lambda_upload.key

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy,
    aws_iam_role_policy_attachment.lambda_s3_access,
    aws_cloudwatch_log_group.lambda_log_group
  ]
}

# ---------------------------------------------------------
# EventBridge Rule (Trigger every 1 minute)
# ---------------------------------------------------------
resource "aws_cloudwatch_event_rule" "lambda_schedule_rule" {
  name                = "lambda-every-1-minute"
  schedule_expression = "rate(1 minute)"
}

# Link Event Rule → Lambda
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_schedule_rule.name
  target_id = "lambda-s3-trigger"
  arn       = aws_lambda_function.my_lambda.arn

  depends_on = [
    aws_lambda_function.my_lambda
  ]
}

# Allow EventBridge to Invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule_rule.arn
}
