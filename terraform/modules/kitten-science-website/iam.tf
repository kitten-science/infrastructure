# Maintainer Access
data "aws_iam_policy_document" "maintainer_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::022327457572:user/oliver"
      ]
    }
  }
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::022327457572:oidc-provider/token.actions.githubusercontent.com"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:kitten-science/kitten-scientists:ref:refs/heads/main"
      ]
    }
  }
}
resource "aws_iam_role" "maintainer" {
  name               = "${var.bucket_name}-maintainer"
  assume_role_policy = data.aws_iam_policy_document.maintainer_assume_role.json
}

data "aws_iam_policy_document" "maintainer" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
  statement {
    effect  = "Allow"
    actions = ["cloudfront:*"]
    resources = [
      aws_cloudfront_distribution.schema.arn,
      aws_cloudfront_distribution.this.arn
    ]
  }
}
resource "aws_iam_policy" "maintainer" {
  name        = "${var.bucket_name}-maintainer"
  description = "Allows changing the Kitten Science website."
  policy      = data.aws_iam_policy_document.maintainer.json
}
resource "aws_iam_role_policy_attachment" "maintainer" {
  role       = aws_iam_role.maintainer.name
  policy_arn = aws_iam_policy.maintainer.arn
}
