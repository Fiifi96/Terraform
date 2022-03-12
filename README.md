# Terraform
Automating the deployment of cloud services- EC2 instance

Main.tf
Automate the deployment of AWS EC2 instance with region "us-east-2"
- EC2 instance type t2.micro
- Generic machine type [In this case Linus 2] 

Shared code with Terraform cloud 
- Organization name - BSAM
- Workspace name - example

Outputs.tf
Prints outputs when Terraform apply is run 
- Prints the instance ID
- Prints the public IP of the instance

Variable.tf
Application of vars to make script more dynamic
- Input instance name
