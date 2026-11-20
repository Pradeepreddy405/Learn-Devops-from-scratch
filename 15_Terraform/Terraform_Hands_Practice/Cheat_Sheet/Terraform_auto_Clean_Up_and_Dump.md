# Terraform Resource Discovery & Cleanup

## Overview

This guide helps identify which Terraform practice folders have successfully created AWS resources, inspect the resources, and destroy them safely.

**Root Directory:**
`Terraform_Hands_Practice`

**Terminal:** Git Bash (MINGW64)

## 1. Find Terraform State Files

```bash
find . -name "terraform.tfstate" -type f
```

**Explanation:** Finds all local Terraform state files across subdirectories.

## 2. Identify Active Terraform Folders

```bash
find . -name "terraform.tfstate" -type f -exec sh -c '
for file do
    DIR=$(dirname "$file")
    RESOURCES=$(terraform -chdir="$DIR" state list 2>/dev/null)

    if [ -n "$RESOURCES" ]; then
        echo "ACTIVE FOLDER: $DIR"
        echo "$RESOURCES"
    fi
done
' sh {} +
```

**Explanation:** Checks each state file and displays folders containing Terraform-managed resources.

## 3. View Terraform Resources

List resources:

```bash
terraform -chdir="./Hands_On_01/Script_01" state list
```

View detailed resource information:

```bash
terraform -chdir="./Hands_On_01/Script_01" show
```

View JSON output:

```bash
terraform -chdir="./Hands_On_01/Script_01" show -json
```

## 4. Preview Resource Destruction

```bash
terraform -chdir="./Hands_On_01/Script_01" plan -destroy
```

**Explanation:** Shows which resources Terraform plans to destroy without actually deleting them.

## 5. Destroy Terraform Resources

```bash
terraform -chdir="./Hands_On_01/Script_01" destroy -auto-approve
```

**Explanation:** Destroys infrastructure managed by the selected Terraform state.

## 6. Verify Resource Destruction

```bash
terraform -chdir="./Hands_On_01/Script_01" state list
```

If the output is empty, no resources remain tracked in that state.

---

## Important Notes

- `terraform.tfstate` tracks infrastructure managed by Terraform.
- A state file containing resources does not guarantee that those resources are currently running.
- Remote backend states are not necessarily stored locally.
- Always inspect the destroy plan before deleting resources.
- Never manually delete state files as a substitute for `terraform destroy`.
- Back up state files before cleanup.

**Recommended Workflow:**

`Discover → Identify → Inspect → Preview → Destroy → Verify`