# Ansible

## 1. How to install on Ubuntu 24

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

### 1.1. Creating configuration file

```shell
sudo mkdir -p /etc/ansible
sudo chown $USER:$USER /etc/ansible
ansible-config init --disabled -t all > /etc/ansible/ansible.cfg
```

### 1.2. Creating inventory

```shell
mkdir /etc/ansible/inventories
sed -i 's|;inventory=/etc/ansible/hosts|inventory=/etc/ansible/inventories|' /etc/ansible/ansible.cfg
touch /etc/ansible/inventories/hosts.yml
```

**hosts.yml**

Two hosts and one group.

```yaml
all:
  hosts:
    device1:
    device2:

mygroup:
  hosts:
    device1:
    device2:
```

