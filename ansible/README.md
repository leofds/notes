# Ansible

## How to install on Ubuntu 24 (local user)

```shell
sudo apt update
sudo apt install pipx -y
pipx install --include-deps ansible
pipx ensurepath
source ~/.bashrc
ansible-config init --disabled -t all > ~/.ansible.cfg
```
Upgrade 
```shell
pipx upgrade --include-injected ansible
```
