# VScode for Toolbox - Simple yet robust helper script for VSCode-Toolbox Integration

This repository contains a simple, modern script automating smooth integration of Toolbox containers and VSCode (Flatpak).

NOTE: This project depends on the Flatpak version of VSCode. If it's missing, the installation script will install it for you.

## Installation

**Make sure you run this from your own user account, not root. The scripts will use `sudo` (and therefore promt you for your password) where necessary.**

```bash
sudo rpm-ostree install podman-compose
cd ~/
git clone https://github.com/daw1012345/vscode-for-toolbox vc-toolbox-helper
cd vc-toolbox-helper && ./install.py
export PATH=$HOME/vc-toolbox-helper/bin:$PATH
```
Make sure to add `$HOME/vc-toolbox-helper/bin` to your `$PATH` in a persistent way (that works within containers).
The approach here depends on the shell of your choice.

- Bash: `echo 'export PATH=$HOME/vc-toolbox-helper/bin:$PATH' >> ~/.bashrc && source ~/.bashrc`
- Fish: `fish_add_path $HOME/vc-toolbox-helper/bin`
## Usage

```bash
toolbox create
toolbox enter
cd ~/my_project && code (Or code ~/my_project)
```

Note: This currently only works with containers created **after** the installation of this tool. Support for existing containers is coming.
## Acknowledgements 
This project is based on [toolbox-vscode](https://github.com/owtaylor/toolbox-vscode). However, that project seems abandoned as it does not work due to changes in VScode.
The more up-to-date method of integrating vscode and toolbox containers is based on the method from [this great article](https://hackandslash.blog/how-to-run-vs-code-flatpak-with-a-toolbox-with-code-completion/).

## Related
- https://github.com/containers/toolbox/pull/1296
- https://hackandslash.blog/how-to-run-vs-code-flatpak-with-a-toolbox-with-code-completion/
- https://github.com/owtaylor/toolbox-vscode
- https://github.com/containers/podman/pull/18492

