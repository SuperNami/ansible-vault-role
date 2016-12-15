# Ansible
vault: download install

download:
	ansible-playbook main.yml -i localhost -t download

install:
	ansible-playbook main.yml -i localhost -t install

configure-dev:
	ansible-playbook main.yml -i localhost -t configure_dev

configure-prod:
	ansible-playbook main.yml -i localhost -t configure_prod


# Galaxy
download-galaxy:
	ansible-galaxy install brianshumate.vault


# Development server
dev: start-dev-server auth

dev-start-server:
	vault server -dev

dev-environment:
	export VAULT_ADDR=http://${VAULT_IP}:${VAULT_PORT}

dev-auth:
	vault auth


# Production server role
prod: configure-prod prod-start-server prod-environment init unseal auth

prod-start-server:
	vault server -config=/etc/vault/vault.hcl

prod-environment:
	export VAULT_ADDR=http://127.0.0.1:8200

init:
	vault init -key-shares=3 -key-threshold=2

unseal:
	vault unseal ${UNSEAL_KEY_1} && vault unseal ${UNSEAL_KEY_2}

auth:
	vault auth ${VAULT_TOKEN}


# Gitlab secrets
gitlab: gitlab-private-token gitlab-hhvm-runner-token gitlab-nginx-runner-token gitlab-percona-runner-token gitlab-php-fpm-runner-token gitlab-redis-runner-token gitlab-website-runner-token

gitlab-private-token:
	vault write secret/gitlab-private-token value=${GITLAB_PRIVATE_TOKEN}

gitlab-hhvm-runner-token:
	vault write secret/gitlab-hhvm-runner-token value=${GITLAB_HHVM_RUNNER_TOKEN}

gitlab-nginx-runner-token:
	vault write secret/gitlab-nginx-runner-token value=${GITLAB_NGINX_RUNNER_TOKEN}

gitlab-percona-runner-token:
	vault write secret/gitlab-percona-runner-token value=${GITLAB_PERCONA_RUNNER_TOKEN}

gitlab-php-fpm-runner-token:
	vault write secret/gitlab-php-fpm-runner-token value=${GITLAB_PHP_FPM_RUNNER_TOKEN}

gitlab-redis-runner-token:
	vault write secret/gitlab-redis-runner-token value=${GITLAB_REDIS_RUNNER_TOKEN}

gitlab-website-runner-token:
	vault write secret/gitlab-website-runner-token value=${GITLAB_WEBSITE_RUNNER_TOKEN}


# Common secrets
common: name tld upstream admin-email wp-user wp-user-password db-user-password mysql-root-password

name:
	vault write secret/name value=${NAME}

tld:
	vault write secret/tld value=${TLD}

upstream:
	vault write secret/upstream value=${UPSTREAM}

admin-email:
	vault write secret/admin-email value=${ADMIN_EMAIL}

wp-user:
	vault write secret/wp-user value=${WP_USER}

wp-user-password:
	vault write secret/wp-user-password value=${WP_USER_PASSWORD}

db-user-password:
	vault write secret/db-user-password value=${DB_USER_PASSWORD}

mysql-root-password:
	vault write secret/mysql-root-password value=${MYSQL_ROOT_PASSWORD}


# Read secrets
read-api:
	curl -H "X-Vault-Token: ${VAULT_TOKEN}" -X GET http://${VAULT_IP}:${VAULT_PORT}/v1/secret/wp-user | jq -r '.data.value'

read-cli:
	vault read -field=value secret/wp-user
