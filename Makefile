apply:
	tofu -chdir=terraform apply

init:
	tofu -chdir=terraform init

lint:
	podman run --rm -v $(shell pwd):/data -t --entrypoint /bin/sh ghcr.io/terraform-linters/tflint -c "tflint --init && tflint --recursive"

plan:
	tofu -chdir=terraform plan

pretty:
	tofu -chdir=terraform fmt -recursive .

upgrade:
	tofu -chdir=terraform init -upgrade
