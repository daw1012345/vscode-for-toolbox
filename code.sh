#!/bin/bash
# This script is vaugely inspired by the toolbox-vscode project on GitHub.
# With this project I meant to simplify the process of using the dev container extension with toolbox
# The toolbox-vscode project seems to be abandoned as it does not work at the moment. A pull request to fix this has not been merged and the code is outdated (simpler methods to achieve the same things exist)
set -e

DES_FOLDER="${1:-"$PWD"}"
DES_FOLDER="$(readlink -f $DES_FOLDER)"

if [ ! -f "/run/.containerenv" ]; then
     echo "[+] Not in container, launching VSCode"
     flatpak run com.visualstudio.code "$DES_FOLDER"
     exit
fi

CONTAINER_NAME="$(source /run/.containerenv && echo $name)"
CONTAINER_ID="$(source /run/.containerenv && echo $id)"
# Copied from toolbox-vscode because xxd is not installed by default
CONTAINER_ID_ENC=$(echo -n "$CONTAINER_ID" | od -t x1 -A none -v | tr -d ' \n')

CONFIG_FILE="$HOME/.var/app/com.visualstudio.code/config/Code/User/globalStorage/ms-vscode-remote.remote-containers/nameConfigs/$CONTAINER_NAME.json"

# By default, VSCode will try to do everything as root messing up permissions. Force it to not do that
if [ ! -f "$CONFIG_FILE" ]; then
cat >> "$CONFIG_FILE" <<EOF
{
  "remoteUser": "\${localEnv:USER}",
}
EOF
fi

if [ -f "$CONFIG_FILE" ] && [ ! 'grep -q "remoteUser" "$CONFIG_FILE"' ]; then
     echo "[!!!!!!] You already have a configuration file for this container but the remoteUser option is missing. No changes will be made, but you may experience issues with permissions."
fi

CTR_ENV="$(flatpak-spawn --host podman inspect ${CONTAINER_ID} --format='{{.Config.Env}}')"
if ! echo "$CTR_ENV" | grep -q "HOME=$HOME" ;then
     echo "[-] Incorrect HOME env is set, this can be (temporairly) solved by running the following on your **host**:"
     echo "sudo sed -i \"s|HOME=[^\\\"]*|HOME=$HOME|g\" $HOME/.local/share/containers/storage/overlay-containers/$CONTAINER_ID/userdata/config.json"
     exit 1
fi

rm -rf "$HOME/.vscode-server" 
sudo mkdir -p /opt/vscode-server/
sudo chmod a+rwx /opt/vscode-server/
ln -T -sf /opt/vscode-server/ "$HOME/.vscode-server" 

echo "[+] Launching VScode..."

# https://github.com/microsoft/vscode-remote-release/issues/5278#issuecomment-1408712695
flatpak-spawn --host flatpak run com.visualstudio.code --folder-uri vscode-remote://attached-container+"$CONTAINER_ID_ENC"/"$DES_FOLDER"
