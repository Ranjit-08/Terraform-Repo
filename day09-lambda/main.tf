# ---------------- IAM Role for Lambda ----------------
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"   # Name of the IAM Role

  # IAM Trust Relationship Policy (Who can assume this role)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"    # Allows role to be assumed
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"  # Lambda service is allowed to use this role
      }
    }]
  })
}

# ---------------- Attach AWS Managed Policy ----------------
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name  # Attach policy to this role
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  # This policy allows Lambda to:
  # - Write logs to CloudWatch
  # - Create log streams automatically
}

# ---------------- Create CloudWatch Log Group ----------------
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/my_lambda_function"
  # This MUST match the Lambda function name to store logs properly

  retention_in_days = 30
  # Optional: Automatically delete logs older than 30 days
  # If you want to keep logs forever, remove this line
}

# ---------------- Create Lambda Function ----------------
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"  # Name visible in AWS Lambda console
  role          = aws_iam_role.lambda_role.arn  # IAM role to use for execution
  handler       = "lambda_function.lambda_handler"
  # handler = <filename>.<function_name>
  # If your file is lambda_function.py and inside it function is lambda_handler -> This is correct

  runtime       = "python3.12"          # Python version to use
  timeout       = 900                   # Max runtime (900 sec = 15 minutes)
  memory_size   = 128                   # Lambda RAM size (affects performance & cost)

  filename         = "lambda_function.zip"
  # ZIP file containing your Lambda code. Must be in the same directory.

  source_code_hash = filebase64sha256("lambda_function.zip")
  # This makes Terraform detect updates to your ZIP and redeploy automatically.
  # If you update your Lambda code but keep same filename, Terraform still deploys new code.

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy,
    aws_cloudwatch_log_group.lambda_log_group
  ]
  # Ensures these resources are created FIRST before deploying Lambda.
  # Prevents errors like: "Log group missing" or "Role not ready"
}
