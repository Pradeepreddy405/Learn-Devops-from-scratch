# Terraform State Conflict Example

This repository demonstrates a common issue in Terraform when **multiple copies/projects work on the same infrastructure without a shared state**.

---

## Problem Description

Without a shared backend, Terraform **cannot detect changes made by another user or project copy**, which can lead to **conflicts and resource overwrites**.

Two copies of Terraform state are shown below, both pointing to the **same VPC**, but with different tags:



Both state files point to the same VPC (vpc-032da2931fe3858cb), but the tags differ:

Copy 1: "Name": "VPC- Dev -B"

Copy 2: "Name": "Vpc-dev-A"

	If one copy applies changes, the other copy will overwrite it, because Terraform only uses local state and cannot detect changes made by another user/project copy.


---

		## Copy 1 - `terraform.tfstate`
		
		```json
		{
		"version": 4,
		"terraform_version": "1.14.4",
		"serial": 3,
		"lineage": "5de65d8b-492c-1bb8-a763-dba52c50f2f7",
		"outputs": {},
		"resources": [
			{
			"mode": "managed",
			"type": "aws_vpc",
			"name": "this",
			"provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
			"instances": [
				{
				"attributes": {
					"id": "vpc-032da2931fe3858cb",
					"cidr_block": "10.0.0.0/16",
					"tags": {
					"Name": "VPC- Dev -B"
					}
				}
				}
			]
			}
		]
		}
		```

		## Copy 2 - `terraform.tfstate`
		```json
		{
		"version": 4,
		"terraform_version": "1.14.4",
		"serial": 3,
		"lineage": "5de65d8b-492c-1bb8-a763-dba52c50f2f7",
		"outputs": {},
		"resources": [
			{
			"mode": "managed",
			"type": "aws_vpc",
			"name": "this",
			"provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
			"instances": [
				{
				"attributes": {
					"id": "vpc-032da2931fe3858cb",
					"cidr_block": "10.0.0.0/16",
					"tags": {
					"Name": "Vpc-dev-A"
					}
				}
				}
			]
			}
		]
		}
		```
### Solution

	1. Use a Remote Backend (Recommended)

		Using a shared backend ensures everyone works from the same source of truth and prevents conflicts.
		Example for AWS S3 + DynamoDB:

		```bash
		terraform {
		backend "s3" {
			bucket         = "my-terraform-state-bucket"
			key            = "vpc/terraform.tfstate"
			region         = "us-east-1"
			dynamodb_table = "terraform-lock"
			encrypt        = true
		}
		}
		```

		Benefits:
		- Shared state among multiple users/projects
		- State locking to prevent concurrent modifications
		- Detects infrastructure changes made by others

	2. Avoid Local .tfstate Copies
		- Do not manually copy .tfstate between machines/projects.
		- Only one .tfstate should serve as the source of truth.


### Summary
	Without a shared backend, Terraform cannot detect external changes, which can cause drift or overwrite resources. Using a remote backend is essential for collaborative Terraform workflows.