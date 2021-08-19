init:
	terraform init -force-copy -backend-config=./tf_backend.cfg
fmt:
	terraform fmt
preview: init
	terraform plan
deploy: init
	terraform apply -auto-approve 
deploy-meta-backend:
	cd meta-backend && terraform init && terraform apply -auto-approve