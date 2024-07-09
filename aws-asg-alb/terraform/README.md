pre-requisites
---------------
-Terraform pre-installed.

-An access key & secret key created the AWS


this iac will create Autoscaling Group , Application Load Balancer , ec2 launch template.

In this setup, the default backend (local backend), which stores the Terraform state file on your local disk, is used for storing the terraform state.

```
cd terraform

terraform init

terraform plan

terraform apply
```
