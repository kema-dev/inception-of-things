#!/bin/bash

function declare_colors_and_set_error() {
	INFO='\033[0;34m'
	SUCCESS='\e[0;32m'
	DIMMED='\e[0;36m'
	RESET='\e[0m'
	set -e
}

function set_k3s_variables() {
	export K3S_KUBECONFIG_MODE="644"
	NODE_IP="${1}"
	EXTERNAL_IP="${NODE_IP}"
	export INSTALL_K3S_EXEC="--node-ip ${NODE_IP} --node-external-ip=${EXTERNAL_IP}"
}


function install_k3s() {
	curl -sfL "https://get.k3s.io" | sh -
}

function copy_token_to_shared_folder() {
	SHARED_FOLDER="/vagrant/shared"
	sudo cp "/var/lib/rancher/k3s/server/node-token" "${SHARED_FOLDER}/server_token"
}

function main() {
	echo -e "${INFO}Installing ${SUCCESS}k3s SERVER${INFO} and related tools (kubectl...)${RESET}"
	declare_colors_and_set_error
	set_k3s_variables "${@}"
	install_k3s
	copy_token_to_shared_folder
	echo -e "${SUCCESS}k3s SERVER${INFO} installed successfully${RESET}"
}

main "${@}"
