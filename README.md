# iac
pre-requisites
---------------
terraform version : v1.6.6 is used.
this iac will create Autoscaling Group , Application Load Balancer , ec2 launch template.
In this setup ,for the storage of terraform state,the default-backend (local backend, which stores the state file on your local disk) is used.
cd terraform
export AWS_PROFILE = yourawsprofile
terraform init
terraform plan
terraform apply
