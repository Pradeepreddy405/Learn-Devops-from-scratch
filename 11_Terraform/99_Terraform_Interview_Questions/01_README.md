#### 1. What is the difference between terraform plan and terraform apply?"
	1 Terraform plan compares the desired configuration with the current infrastructure state and previews proposed changes.
	2 Terraform apply executes the changes after approval (or automatically with -auto-approve).


#### 2 What is the purpose of Terraform state?"
	Terraform state maintains Terraform's record of managed infrastructure and maps configuration resources to real infrastructure objects. It helps Terraform determine what needs to be created, modified or destroyed.