#------------------------------AZURE------------------------------------------------
#!/usr/bin/env bash
# set -euo pipefail

# ENV="$1"

# if [ -z "$ENV" ]; then
#   echo "Usage: ./init.sh <environment>"
#   exit 1
# fi

# terraform init \
#   -backend-config="resource_group_name=tfstate-rg" \
#   -backend-config="storage_account_name=tfstateaccount" \
#   -backend-config="container_name=tfstate" \
#   -backend-config="key=${ENV}.terraform.tfstate"

#--------------------------------------AWS---------------------------------------
# !/usr/bin/env bash
set -euo pipefail

ENV="$1"

terraform init \
  -backend-config="bucket=my-terraform-state-bucket" \
  -backend-config="key=${ENV}/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="dynamodb_table=terraform-locks" \
  -backend-config="encrypt=true"