# ADR 001: Remote state management strategy

## Status
Accepted

## Context
Terraform state must be shared, recoverable, and protected against concurrent modification across multiple environments. Local state does not provide sufficient collaboration controls, recovery features, or safe handling for team-oriented workflows.

This repository requires separate state for `dev`, `stg`, and `prod` so that changes in one environment do not affect another environment. The backend must also support versioned recovery, encryption at rest, and basic access hardening.

HashiCorp documents that DynamoDB-based state locking for the S3 backend is deprecated in favour of S3 native lockfiles. However, this repository intentionally implements S3 state storage with DynamoDB locking to make remote state coordination explicit and easy to review in code while maintaining compatibility with common existing AWS-based Terraform workflows.

## Decision
Use a dedicated bootstrap configuration to provision the Terraform backend in AWS `ap-southeast-2`.

The backend implementation will use:
- An Amazon S3 bucket for remote Terraform state storage
- S3 bucket versioning for state recovery
- Server-side encryption for state objects
- Public access block settings on the state bucket
- A bucket policy denying insecure transport
- An Amazon DynamoDB table for Terraform state locking
- Distinct backend keys for `dev`, `stg`, and `prod`

Environment state will be isolated by backend key:
- `dev/core/terraform.tfstate`
- `stg/core/terraform.tfstate`
- `prod/core/terraform.tfstate`

Credentials will not be hardcoded in backend configuration. AWS credentials will be provided through the standard AWS credential chain.

The implementation may be revised later to adopt S3 native locking when that becomes the preferred operational approach for this repository.

## Consequences
**Positive:**
- Enables shared remote state for team-oriented Terraform workflows
- Reduces the risk of state corruption from concurrent changes
- Provides state recovery through S3 object versioning
- Separates environment state to limit blast radius
- Makes backend security controls visible in code and documentation

**Negative:**
- Introduces additional bootstrap resources that must be created before environment deployment
- Requires operators and CI workflows to have access to backend resources
- Uses a locking mechanism that HashiCorp has marked for future removal
- Adds a migration task if the repository later adopts S3 native locking
