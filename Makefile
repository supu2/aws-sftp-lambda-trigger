
APP_NAME=sftp-client
current_dir = $(shell pwd)
var = test-us-east-1.tfvars

# HELP
# This will output the help for each task
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

prepare: genkey replace_key ## Generate ssh-key pairs and replace variables

genkey: 
	ssh-keygen -f ssh/id_rsa -P ""

replace_key: 
	sed -i 's|public_key = ".*"|public_key = "$(shell cat ssh/id_rsa.pub)"|g' infra/$(var)

# Build the container
build: ## Build the container
	docker build -t $(APP_NAME) .

run: ## Run container for the test
	docker run -i -t --rm -v  $(current_dir)/ssh/:/home/sftp/.ssh/  -v $(current_dir)/test/:/opt/ --name="$(APP_NAME)" $(APP_NAME)

stop: ## Stop and remove a running container
	docker stop $(APP_NAME); docker rm $(APP_NAME) 

deploy: ## Deploy to aws with terraform
	cd infra ;\
	terraform init ;\
	terraform plan --var-file=$(var);\
	terraform apply --var-file=$(var)

destroy: ## Destroy aws infra
	cd infra; \
	terraform destroy --var-file=$(var)

clean: ## Clean the config
	docker stop $(APP_NAME); docker rm $(APP_NAME) ; sed -i 's/^public_key.*/public_key = "#####"/g'  infra/$(var); rm -rf ssh/*