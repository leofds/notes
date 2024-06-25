# Ansible

## How to install on Ubuntu 24

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

### Creating inventory

```shell
mkdir /etc/ansible/inventories
sed -i 's|;inventory=/etc/ansible/hosts|inventory=/etc/ansible/inventories|' /etc/ansible/ansible.cfg
touch /etc/ansible/inventories/hosts.yml
```

**hosts.yml (creating hosts)**

```yaml
all:
  hosts:
    device1:
    device2:
```
