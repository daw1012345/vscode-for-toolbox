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

VSCODE_GLOBAL_CONFIG="$HOME/.var/app/com.visualstudio.code/config/Code/User/settings.json"

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

# Install extension that will allow VScode to access podman from the flatpak
flatpak-spawn --host flatpak install com.visualstudio.code.tool.podman//22.08/ --noninteractive -y

# Allow vscode to reach podman from within the sandbox
flatpak-spawn --host flatpak override --user --filesystem=xdg-run/podman com.visualstudio.code

if [ ! -f "$VSCODE_GLOBAL_CONFIG" ]; then
     mkdir -p "$(dirname "$VSCODE_GLOBAL_CONFIG")"
     echo "{}" > "$VSCODE_GLOBAL_CONFIG"
fi

# Update vscode configuration to make use of podman instead of docker (toolbox uses podman and the two are interchangable)
# At first glance this may seem weird, but using sed to write JSON is finicky at best and jq is not installed on Fedora by default. AFAIK python should at least be available on the host
flatpak-spawn --host python3 <<EOF
import json

with open("$VSCODE_GLOBAL_CONFIG", 'r+') as fd:
	data = json.loads(fd.read())
	data['dev.containers.dockerPath'] = '/app/tools/podman/bin/podman-remote'
	data['dev.containers.dockerComposePath'] = 'podman-compose'
	fd.seek(0)
	fd.write(json.dumps(data))
EOF

# Actually make sure that we have the remote containers vscode extension
flatpak-spawn --host flatpak run com.visualstudio.code --install-extension ms-vscode-remote.remote-containers

echo "[+] Launching VScode..."

# https://github.com/microsoft/vscode-remote-release/issues/5278#issuecomment-1408712695
flatpak-spawn --host flatpak run com.visualstudio.code --folder-uri vscode-remote://attached-container+"$CONTAINER_ID_ENC"/"$DES_FOLDER"
