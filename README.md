# VScode for Toolbox - Simple yet robust helper script for VSCode-Toolbox Integration

This repository contains a simple, modern script automating smooth integration of Toolbox containers and VSCode (Flatpak).

## Installation

```bash
cd ~/
git clone https://github.com/daw1012345/vscode-for-toolbox vc-toolbox-helper
cd vc-toolbox-helper && ./install.py

```

## Usage

```bash
toolbox create
toolbox enter
cd ~/my_project && code (Or code ~/my_project)
```

## Issues
- VSCode will not place files in the correct directory until [this issue](https://github.com/containers/toolbox/pull/1296) gets resolved. The home directory VSCode tries to write to will always be `/root` as Toolbox doesn't set the appripriate environment variable. A fix is autosuggested by the tool if required.

## Acknowledgements 
This project is based on [toolbox-vscode](https://github.com/owtaylor/toolbox-vscode). However, that project seems abandoned as it does not work due to changes in VScode.
The more up-to-date method of integrating vscode and toolbox containers is based on the method from [this great article](https://hackandslash.blog/how-to-run-vs-code-flatpak-with-a-toolbox-with-code-completion/).

## Related
- https://github.com/containers/toolbox/pull/1296
- https://hackandslash.blog/how-to-run-vs-code-flatpak-with-a-toolbox-with-code-completion/
- https://github.com/owtaylor/toolbox-vscode
- https://github.com/containers/podman/pull/18492

