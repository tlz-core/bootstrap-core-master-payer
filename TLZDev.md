## TLZ Dev Setup

### Background
In order to test terraform code related to the landing zone, we need a develop
AWS account. We initially used AWS landing zone solution and then changed
to use the Terraform landing zone solution. We did install the TLZ on top of
what was left of the AWS Landing zone.

In order to capture the installation instruction properly in a brand new account
we created a new account and capture the steps below:

### The following steps were followed:

1. Open new AWS account and provide contact details along with a reserved email
address. 
1. Proceed to enable MFA on the root account. When the MFA image is provided,
capture a screenshot and upload to the cirrus space in watchdox. This step
will have to be different for a production account. Infosec needs to be the
keepers of the MFA for the prod account and potentially the lastpass credentials
as well.
1. Confirmed the password in lastpass and MFA in watchdox is working by
requesting a team member to check. As noted this step will have to move to
infosec for prod account
1. Update the Billing, Ops and Security contacts to use the same email as was
used for the root account creation
1. Sent email to account manager requesting our account to be put on invoicing.
Once account manager approved the change confirm in the billing console
1. Create new IAM user named `terraform_svc` with admin credentials and assign
key in order to run terraform script from workstation
1. Run terraform script to create resmed organization, it is required to
increase sub account limit. To run the `bootstrap.tf` one needs to
have the IAM secret set for this account and run from workstation **NOTE not
liking this secret on a workstation**. A verification email will be sent to the
root account email address. Click verify to complete the organization creation.
The bootstrap script will also add a budget alarm. The SNS topic email also
needs to be configured correctly prior to running the script and then verified
on reception of email verification.
1. Once organization is created via script, create support ticket via AWS console
to request a sub account limit increase.
1. Disable the secret for the `terraform_svc` user
