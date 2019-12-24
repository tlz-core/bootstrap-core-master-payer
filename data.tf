data "aws_iam_policy_document" "shared_svcs_assume_role_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${aws_organizations_account.shared_svcs.id}:root"]
    }

    actions = ["sts:AssumeRole"]
  }
}
