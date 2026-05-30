# GitHub Actions OIDC configuration for Terraform plan

## Overview

The `terraform-plan` workflow uses GitHub Actions OpenID Connect (OIDC) to assume an AWS IAM role without storing long-lived AWS access keys in GitHub.

## Required repository variables

Configure the following repository variables before enabling the workflow:

| Name | Description |
| --- | --- |
| `TERRAFORM_AWS_ROLE_ARN` | IAM role ARN assumed by GitHub Actions for Terraform plan |
| `TERRAFORM_STATE_BUCKET` | S3 bucket name used for Terraform remote state |
| `TERRAFORM_LOCK_TABLE` | DynamoDB table name used for Terraform state locking |
| `TERRAFORM_ALLOWED_ACCOUNT_ID` | AWS account ID expected by the workflow |

## AWS OIDC provider settings

Create an IAM OIDC identity provider with the following values:

- Provider URL: `https://token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`

## Sample IAM trust policy

Replace the placeholders with your own values.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<AWS_ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<GITHUB_ORG>/<GITHUB_REPOSITORY>:*"
        }
      }
    }
  ]
}
```

## Notes

- Restrict the role permissions to the minimum set required for Terraform planning.
- Tighten the `sub` condition further if you use protected branches or GitHub environments.
- The workflow uses environment-specific backend keys:
  - `environments/dev/terraform.tfstate`
  - `environments/stg/terraform.tfstate`
  - `environments/prod/terraform.tfstate`
- The workflow uses `pull_request`, not `pull_request_target`, to avoid granting AWS credentials to untrusted code paths.
