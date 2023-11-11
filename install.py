#!/usr/bin/env python3
import json
import os

"""Tell VSCode to use Podman instead of Docker"""
def write_vscode_config():
    print("Telling VSCode to use podman instead of Docker")
    global_config_path = os.path.expanduser('~/.var/app/com.visualstudio.code/config/Code/User/settings.json')
    with open(global_config_path, 'r+') as fd:
        try:
            data = json.loads(fd.read())
        except ValueError:
            data = dict()

        data['dev.containers.dockerPath'] = '/app/tools/podman/bin/podman-remote'
        data['dev.containers.dockerComposePath'] = 'podman-compose'
        fd.seek(0)
        fd.truncate()
        fd.write(json.dumps(data))

"""Install extension allowing containerized VSCode to use Podman on the host and the dev containers extension"""
def install_portal():
    print("Installing VSCode -> Podman portal")
    os.system("flatpak install com.visualstudio.code.tool.podman//22.08/ --noninteractive -y")
    print("Allowing VSCode to use Podman")
    os.system("flatpak override --user --filesystem=xdg-run/podman com.visualstudio.code")
    print("Installing the Remote Containers VSCode extension")
    os.system("flatpak run com.visualstudio.code --install-extension ms-vscode-remote.remote-containers")
    print("Creating configuration directory")
    os.system("mkdir -p $HOME/.var/app/com.visualstudio.code/config/Code/User/globalStorage/ms-vscode-remote.remote-containers/nameConfigs/")

if __name__ == "__main__":
    install_portal()
    write_vscode_config()