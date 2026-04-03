

## S3 Backend Configuration

The remote backend is configured in `terraform/provider.tf` with the following settings:

```hcl

terraform {

  required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "~> 6.0"

    }

  }

  

  backend "s3" {

    bucket        = "tony-terraform-backend-lab-2026"

    key           = "terraform/state"

    region        = "us-west-2"

    encrypt       = true

  }

}

  

provider "aws" {

  region = "us-west-2"

}

```

  

**Note:** The `use_lockfile` option was requested but is **not a valid Terraform S3 backend argument**. It causes an error:

```

An argument named "use_lockfile" is not expected here.

```

  

With the standard S3 backend, state locking is handled via DynamoDB (not a lock file in S3).

  

## Lab Questions

  

### When is the state file created?

  

The state file (`terraform/state`) is created in the S3 bucket **after `terraform apply` completes successfully**.

  

Observations:

- After `terraform init`: Bucket is empty

- After `terraform plan`: Bucket is empty  

- After `terraform apply` completes: State file appears in S3

  

### When is the lock file present?

  

With the standard Terraform S3 backend, there is **no lock file stored in the S3 bucket**.

  

The S3 backend does not create a lock file like local backends do. Instead, state locking with S3 backends requires AWS DynamoDB to be configured separately:

  

```hcl

backend "s3" {

  bucket        = "tony-terraform-backend-lab-2026"

  key           = "terraform/state"

  region        = "us-west-2"

  encrypt       = true

  # State locking requires DynamoDB table (not a lock file)

  dynamodb_table = "terraform-state-lock"

}

```

  

### Is the lock file always in the bucket after it is created?

  

Since there is no lock file in the S3 bucket with the standard S3 backend, the answer is No. The only file in the bucket is the state file (`terraform/state`).

  

## Screenshots

### State File Only

![[state-file.png]]
*Screenshot showing only the state file in the S3 bucket*

  

### Lock File and State File

![[lock-file.png]]


  

## Files in This Repository

  

```

├── README.md

└── terraform/

    ├── server.tf        # EC2 instance configuration

    └── provider.tf     # AWS provider + S3 backend config

```

  

## Cleanup

  

To clean up the resources:

  

```bash

# Destroy Terraform resources

cd terraform

terraform destroy -auto-approve

  

# Delete the S3 bucket

cd ../scripts

./delete-bucket tony-terraform-backend-lab-2026

```