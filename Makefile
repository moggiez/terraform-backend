init:
	terraform init
fmt:
	terraform fmt
preview:
	terraform init && terraform plan
deploy:
	terraform init && terraform apply -auto-approve