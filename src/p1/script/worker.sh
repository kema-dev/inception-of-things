#!/bin/bash

function declare_colors_and_set_error() {
	INFO='\033[0;34m'
	SUCCESS='\e[0;32m'
	DIMMED='\e[0;36m'
	RESET='\e[0m'
	set -e
}

function set_k3s_variables() {
	SERVER_PROTOCOL="https"
	SERVER_IP="${1}"
	SERVER_PORT="6443"
	export K3S_URL="${SERVER_PROTOCOL}://${SERVER_IP}:${SERVER_PORT}"
	SHARED_FOLDER="/vagrant/shared"
	SERVER_TOKEN_FILE_FOLDER="${SHARED_FOLDER}"
	SERVER_TOKEN_FILE_NAME="server_token"
	export K3S_TOKEN="$(cat ${SERVER_TOKEN_FILE_FOLDER}/${SERVER_TOKEN_FILE_NAME})"
	NODE_IP="${2}"
	EXTERNAL_IP="${NODE_IP}"
	export INSTALL_K3S_EXEC="--node-ip ${NODE_IP} --node-external-ip=${EXTERNAL_IP}"
}

function install_k3s() {
	curl -sfL "https://get.k3s.io" | sh -
	systemctl enable --now k3s-agent
}

function main() {
	echo -e "${INFO}Installing ${SUCCESS}k3s WORKER${INFO} and related tools (kubectl...)${RESET}"
	declare_colors_and_set_error
	set_k3s_variables "${@}"
	install_k3s
	echo -e "${SUCCESS}k3s WORKER${INFO} installed successfully${RESET}"
}

main "${@}"
