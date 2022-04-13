# Creating Lambda IAM resource
resource "aws_iam_role" "lambda_iam" {
  name = var.lambda_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "lambda_policy" {
    statement {
    sid = "1"

    actions = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
    ]

    resources = [
            "arn:aws:s3:::${var.bucket_name}/*",
            ]
  }
   statement {
    sid = "2"

    actions = [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:PutLogEvents" 
    ]

    resources = [
            "arn:aws:logs:*:log-group:/aws/lambda/${var.function_name}:*"
            ]
  }
}


resource "aws_iam_role_policy" "revoke_keys_role_policy" {
  name = var.lambda_iam_policy_name
  role = aws_iam_role.lambda_iam.id

  policy = data.aws_iam_policy_document.lambda_policy.json
}

# Creating Lambda resource
resource "aws_lambda_function" "test_lambda" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_iam.arn
  handler          = "src/${var.handler_name}.lambda_handler"
  runtime          = var.runtime
  timeout          = var.timeout
  filename         = "../src.zip"
  source_code_hash = filebase64sha256("../src.zip")
  environment {
    variables = {
      env            = var.environment
    }
  }
}


# Adding S3 bucket as trigger to my lambda and giving the permissions
resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = var.bucket_id
  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*"]

  }
}
resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_id}"
}
