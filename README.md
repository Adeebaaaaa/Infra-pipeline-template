#  Terraform Infrastructure CI/CD Pipeline

It safely manages infrastructure across:

DEV → BETA → PROD

The pipeline includes:

-  Pre-merge validation
-  Intent-aware drift detection
-  Automatic Terraform import support
-  Controlled environment promotion
-  Commit SHA–based deployment locking


---

#  Key Concept (Very Important)

This pipeline promotes the **same commit SHA** across environments.

That means:

- DEV deploys a specific commit
- BETA can only deploy that exact same commit
- PROD can only deploy that exact same commit

No environment can deploy unless the previous one has promoted the same commit SHA.

This guarantees:

- Deployment consistency  
- Code immutability  
- Full traceability  
- No accidental mismatched deployments  


---

#  Repository Structure

```
.github/workflows/
├── infra-pipeline.yml # Main reusable Terraform workflow
├── iac-dev.yml # DEV environment workflow
├── iac-beta.yml # BETA environment workflow
├── iac-prod.yml # PROD environment workflow

```


---

#  Reusable Pipeline (infra-pipeline.yml)

This is the **main workflow file**, and all other environment workflow files depend on this.

Each environment (dev, beta, prod) calls this workflow using `workflow_call`.

It contains the complete CI/CD logic for:

- Validation
- Planning
- Drift detection
- Import
- Apply
- Promotion tagging


---

#  Pipeline Stages Explained

## 1️⃣ Pre-Merge Checks

Runs quality and security checks:
terraform fmt
terraform init (without backend)
terraform validate
tflint
gitleaks

If any of these fail, the pipeline stops.


---

## 2️⃣ Terraform Plan

- Initializes Terraform
- Generates:
  - Binary plan file (`.tfplan`)
  - JSON plan file (`.json`)
- Uploads plan as an artifact

This ensures the same plan is used later during apply.


---

## 3️⃣ Drift Detection (Intent-Aware)

This stage checks whether infrastructure was changed outside Terraform.

### Logic:

- If no Terraform state exists → first deployment → skip drift check
- If state exists:
  - Detects create / update / delete actions
  - Checks if `.tf` files were changed

### Outcomes:

| Scenario | Result |
|----------|--------|
| Infra changed + Terraform code changed | Allowed |
| Infra changed + No Terraform code change |  Fails (Drift detected) |
| No infra change |  Continue |

This prevents manual AWS console changes from going unnoticed.


---

## 4️⃣ Terraform Import (Drift Recovery)

If drift is detected:

The pipeline can import unmanaged resources into state.

Required variables:
TF_IMPORT_ADDRESS
TF_IMPORT_ID

After import, Terraform re-plans to ensure alignment.


---

## 5️⃣ Terraform Apply

- Applies the previously generated plan
- Saves Terraform outputs
- Creates a promotion marker using the commit SHA


---

# Commit SHA Promotion Model

This pipeline uses commit SHA across the entire promotion flow.

When DEV deployment succeeds:

dev-<commit-sha>
A GitHub Release is created.

Before BETA runs, it verifies:
dev-<commit-sha>

Before PROD runs, it verifies:

beta-<commit-sha>

If the required promotion release does not exist, the deployment fails.

This ensures:

- The exact same commit is promoted
- No environment runs different code
- Production always matches tested commits


---

#  Environment Workflows

## DEV (iac-dev.yml)

- Triggered manually
- Calls reusable workflow
- Creates:
    dev-<commit-sha>


## BETA (iac-beta.yml)

- Verifies DEV promotion exists
- Calls reusable workflow
- Creates:
      beta-<commit-sha>


## PROD (iac-prod.yml)

- Verifies BETA promotion exists
- Calls reusable workflow
- Deploys to production


---

#  Destroy

Terraform destroy:

- Only runs via `workflow_dispatch`
- Requires environment approval
- Is intentionally restricted for safety


---

# Typical Deployment Flow

1. Run DEV
2. Validate infrastructure
3. DEV promotion release created
4. Run BETA (same commit)
5. Validate again
6. BETA promotion release created
7. Run PROD (same commit)

All environments use the **same commit SHA**.


---

#  What This Pipeline Protects You From

- Infrastructure drift
-  Manual AWS console changes
-  Deploying different commits per environment
-  Skipping environment promotion



---








