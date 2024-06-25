# Ansible

## How to install on Ubuntu 24 (local user)

```shell
sudo apt update
sudo apt install pipx -y
pipx install --include-deps ansible
pipx ensurepath
source ~/.bashrc
```

### Upgrade

```shell
pipx upgrade --include-injected ansible
```

## Setup

[doc](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)

Create the `ansible.cfg` file on `/etc/ansible`.

```shell
ansible-config init --disabled -t all > ansible.cfg
sudo install -Dm744 ansible.cfg /etc/ansible/ansible.cfg
sudo chown $USER:$USER -R /etc/ansible
rm ansible.cfg
```
