output "shared-services-account" {
  value       = "${aws_organizations_account.shared_svcs.id}"
  description = "Account id of core-shared-services"
}

output "logging-account" {
  value       = "${aws_organizations_account.logging.id}"
  description = "Account id of core-logging"
}

output "security-account" {
  value       = "${aws_organizations_account.security.id}"
  description = "Account id of core-security"
}

output "org-id" {
  value       = "${aws_organizations_organization.org.roots.0.id}"
  #value       = "${data.aws_organizations_organization.org.id}"
  description = "Organization Id"
}

output "core-ou-id" {
  value       = "${aws_organizations_organizational_unit.core.id}"
  description = "core-ou-id"
}

output "trust_shared_services_role" {
  value       = "${aws_iam_role.trust_shared_services.arn}"
  description = "trust_shared_services role"
}

