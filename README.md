# Terraform Backend

Used to setup the Terraform Backend for all projects in this organisation.

Terraform backend makes sure many developers could work on a project simultaneously.

# Setup

## Deploy the Meta Backend (i.e. the backend for the backend project)

- Run `make deploy-meta-backend` and provide the `namespace` (should be unique)
  NB! The meta backend `.state` file will appear locally and be ignored by git. Don't include it. If you need to destroy the meta backend, do it manually via the AWS console.

## Deploy backends

- Run `source ./scripts/gen-tf-config.sh` to generate the terraform backend configuration (provide `moggies.io` for namespace by default)

- Run `make deploy` and provide the `namespace` for the backends if asked to
