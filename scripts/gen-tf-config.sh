echo "Enter namespace (again):"
read tf_namespace
echo "bucket=\"${tf_namespace}-meta-terraform-state-backend\"
dynamodb_table=\"${tf_namespace}-meta-terraform_state\"
key=\"terraform.state\"
region=\"eu-west-1\"" > tf_backend.cfg
export TF_VAR_namespace=${tf_namespace}