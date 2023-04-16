# VScode for Toolbox - Simple yet robyst helper script for VSCode-Toolbox Integration

The repository consists of a single script that properly configures VScode for using Toolbox containers.

## Installation

```bash
cd ~/
git clone https://github.com/daw1012345/vscode-for-toolbox .vc-toolbox-helper
mkdir -p ~/.local/bin
ln -s ~/.vc-toolbox-helper/code.sh ~/.local/bin/code

```

## Usage

```bash
toolbox create
toolbox enter
cd ~/my_project && code
(Alternatively) code ~/my_project
```

## Acknowledgements 
This project is based on [toolbox-vscode](https://github.com/owtaylor/toolbox-vscode). However, that project seems abandoned as it does not work due to changes in VScode.
The more up-to-date method of integrating vscode and toolbox containers is based on the method from [this great article](https://hackandslash.blog/how-to-run-vs-code-flatpak-with-a-toolbox-with-code-completion/).