data "aws_iam_policy_document" "redirect_assume" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "edgelambda.amazonaws.com",
        "lambda.amazonaws.com"
      ]
    }

    actions = ["sts:AssumeRole"]
  }

  provider = aws.global
}

data "aws_iam_policy" "aws_xray_write_only_access" {
  name = "AWSXRayDaemonWriteAccess"
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name_prefix = "lambda-redirect-logging"
  path        = "/"
  description = "IAM policy for logging from a Lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json

  provider = aws.global
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.redirect.name
  policy_arn = aws_iam_policy.lambda_logging.arn

  provider = aws.global
}
resource "aws_iam_role_policy_attachment" "aws_xray_write_only_access" {
  role       = aws_iam_role.redirect.name
  policy_arn = data.aws_iam_policy.aws_xray_write_only_access.arn

  provider = aws.global
}

resource "aws_iam_role" "redirect" {
  name_prefix        = "lambda-${var.lambda_function_name}"
  assume_role_policy = data.aws_iam_policy_document.redirect_assume.json

  provider = aws.global
}

data "archive_file" "redirect" {
  output_file_mode = "0666"
  output_path      = "lambda-pkg-redirect.zip"
  source_file      = "${path.module}/redirect.js"
  type             = "zip"
}

resource "aws_lambda_permission" "edgelambda" {
  statement_id  = "AllowLambdaEdge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "edgelambda.amazonaws.com"
  source_arn    = aws_cloudfront_distribution.this.arn

  provider = aws.global
}

resource "aws_cloudwatch_log_group" "redirect" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14

  provider = aws.global
}

resource "aws_lambda_function" "redirect" {
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.redirect
  ]

  description      = "Redirects requests to release URLs"
  filename         = "lambda-pkg-redirect.zip"
  function_name    = var.lambda_function_name
  handler          = "redirect.handler"
  publish          = true
  role             = aws_iam_role.redirect.arn
  runtime          = "nodejs22.x"
  source_code_hash = data.archive_file.redirect.output_base64sha256

  logging_config {
    log_format = "Text"
  }

  tracing_config {
    mode = "Active"
  }

  // Replicated Lambda@Edge functions take ~30 minutes to be destroyed.
  // It's best to just skip the destruction and clean leftovers manually, if needed.
  skip_destroy = true

  provider = aws.global
}
