                                Servian Technical Challenge

Pre-requisites
=============
- AWS cloud account with AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and admin rights
- Install Terraform and Terragrunt
- AWS CLI
- kubectl
- tfenv
- Domain Name or Domain Certificate to import

Folder Structure
================
terraform-code > root folder
 - dev >Environment name
   - account-2463 >AWS account
     - us-east-2 >Region
       - servian >Project
       - project.hcl > Contains Project related variables
     region.hcl > Contains aws region related variables
   account.hcl > Contains aws account related variables
 env.hcl  > Contains env related variables
terragrunt.hcl > Backend details

Steps
======
1. Please update env.hcl, account.hcl, region.hcl and project.hcl file with details.
2. Note AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY for your user. If you do not have please create the same.
3. Go to aws-configure-script and run terraform init and terraform apply.
Note: Provide same aws-region and profile_name from region.hcl and account.hcl respectively.
Note: Command throws error however it adds details to .aws/credentials and .aws/config file
4. Verify details are added to your .aws/credentials and .aws/config
5. Please set source as aws modules absolute path if it is required. 
6. Run terragrunt init and terragrunt apply command on below folder in sequence
   - iam
     - policies
       - cluster-policies
   - aws-data
   - vpc
   - key-pair
   - security-group
     - sg-nodes
     - sg-rds
   - route53
     NOTE: NS Record of Hosted Zone need to be added if you have purchased domain from other vendor 
   - acm
     NOTE: Please note ACM ARN from the output, this is required for ingress creation
   - eks-cluster
     - execute command- export KUBE_CONFIG_PATH='~/.kube/config 
     - eks-cluster > search "changeme" in terragrunt.hcl and update user details
     - eks-node
   - eks
     - cluster-autoscalar 
       - cluster-autoscalar-namespace
       - cluster-autoscalar
     - ingress-nginx
       - ingress-nginx-namespace
       - ingress-nginx  > search "changeme" in values.yaml and update the ACM ARN
     - argocd 
       - argocd-namespace
       - argocd  > search "changeme" in values.yaml and update the domain
         Run Below Command to find External ip of "ingress-nginx-controller"
            - kubectl get svc -n ingress-nginx
            - Add argocd cname record to your dns
         Note:Refer to README.MD under argocd folder for getting initial password
     - vault
       - vault-namespace
       - vault  > search "changeme" in values.yaml and update the domain
         NOTE: For Further vault setup refer README.MD under vault folder
     - execute tfenv install 0.12.30
       - tfenv use 0.12.30
     - aws-sns
        Go to your email (provided in project.hcl as sns_endpoint) and confirm subscription
     - techapp-rds