# Ansible

## How to install on Ubuntu 24 (local user)

```shell
sudo apt update
sudo apt install pipx -y
pipx install --include-deps ansible
pipx ensurepath
source ~/.bashrc
```

Upgrade

```shell
pipx upgrade --include-injected ansible
```

### Creating configuration file

```shell
sudo mkdir -p /etc/ansible
sudo chown $USER:$USER /etc/ansible
ansible-config init --disabled -t all > /etc/ansible/ansible.cfg
```
