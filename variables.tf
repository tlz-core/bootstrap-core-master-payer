variable "region" {
  type        = "string"
  description = "Region to use for the AWS provider"
}

variable "profile" {
  type        = "string"
  description = "AWS CLI profile for terraform to execute with"
  default     = "ROOT_DELETE_ME"
}

variable "stack" {
  type        = "string"
  description = "Name of the stack to use in tagging"
  default     = "TLZ"
}

variable "environment" {
  type        = "string"
  description = "Environment type this will be deploying(Dev/Prod?)"
}

variable "alarms_email" {
  type        = "string"
  description = "Email address to use for billing alarms in the new account"
}

variable "monthly_billing_threshold" {
  description = "The threshold for which estimated monthly charges will trigger the metric alarm."
  default     = "800"
}

variable "currency" {
  type        = "string"
  description = "Short notation for currency type to use for account billing (e.g. USD, CAD, EUR)"
  default     = "USD"
}

variable "logging_name" {
  description = "Name/Alias of the shared services account"
  type        = "string"
  default     = "core-logging"
}

variable "logging_email" {
  description = "Email for the shared services account"
  type        = "string"
}

variable "security_name" {
  description = "Name/Alias of the shared services account"
  type        = "string"
  default     = "core-security"
}

variable "security_email" {
  description = "Email for the shared services account"
  type        = "string"
}

variable "shared_svcs_name" {
  description = "Name/Alias of the shared services account"
  type        = "string"
  default     = "core-shared-services"
}

variable "shared_svcs_email" {
  description = "Email for the shared services account"
  type        = "string"
}

variable "org_admin_role" {
  description = "Name of the admin roles establishing the trust between the master payer account and the shared services account"
  type        = "string"
  default     = "tlz_organization_account_access_role"
}

variable "trust_shared_services_policy" {
  description = "Arn of policy the master payer account will use to trust shared services"
  type        = "string"
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}

