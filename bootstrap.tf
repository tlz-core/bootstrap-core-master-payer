provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

#################
# Organizations #
#################

#################
# Organizations #
#################

resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set          = "ALL"
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
}

# data "aws_organizations_organization" "org" {}
resource "aws_organizations_organizational_unit" "core" {
  name      = "core"
  parent_id = "${aws_organizations_organization.org.roots.0.id}"
  #parent_id = "${data.aws_organizations_organization.org.roots.0.id}"
}

resource "aws_organizations_account" "logging" {
  name      = "${var.logging_name}"
  email     = "${var.logging_email}"
  role_name = "${var.org_admin_role}"
  parent_id = "${aws_organizations_organizational_unit.core.id}"

  # There is no AWS Organizations API for reading role_name so
  # leaving this out will cause new resource creation each run
  lifecycle {
    ignore_changes = ["role_name"]
  }
}

resource "aws_organizations_account" "security" {
  name      = "${var.security_name}"
  email     = "${var.security_email}"
  role_name = "${var.org_admin_role}"
  parent_id = "${aws_organizations_organizational_unit.core.id}"


  # There is no AWS Organizations API for reading role_name so
  # leaving this out will cause new resource creation each run
  lifecycle {
    ignore_changes = ["role_name"]
  }
}

resource "aws_organizations_account" "shared_svcs" {
  name      = "${var.shared_svcs_name}"
  email     = "${var.shared_svcs_email}"
  role_name = "${var.org_admin_role}"
  parent_id = "${aws_organizations_organizational_unit.core.id}"


  # There is no AWS Organizations API for reading role_name so
  # leaving this out will cause new resource creation each run
  lifecycle {
    ignore_changes = ["role_name"]
  }
}

#######
# IAM #
#######

resource "aws_iam_role" "trust_shared_services" {
  name = "${var.org_admin_role}"

  assume_role_policy = "${data.aws_iam_policy_document.shared_svcs_assume_role_policy.json}"

  tags = {
    "stack"     = "${var.stack}"
    "stack:env" = "${var.environment}"
  }
}

resource "aws_iam_role_policy_attachment" "trust_shared_services" {
  role       = "${aws_iam_role.trust_shared_services.name}"
  policy_arn = "${var.trust_shared_services_policy}"
}

#######
# SNS #
#######

resource "aws_sns_topic" "alarm" {
  name = "alarms-topic"

  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF

  provisioner "local-exec" {
    command = "aws sns subscribe --profile ${var.profile} --region ${var.region} --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
  }
}

##############
# Cloudwatch #
##############

resource "aws_cloudwatch_metric_alarm" "billing" {
  alarm_name          = "billing-alarm-${lower(var.currency)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "28800"
  statistic           = "Maximum"
  threshold           = "${var.monthly_billing_threshold}"
  alarm_actions       = ["${aws_sns_topic.alarm.arn}"]

  dimensions = {
    Currency = "${var.currency}"
  }
}
