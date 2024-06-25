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
      ansible_host: "192.168.0.10"
      ansible_ssh_user: "leo"
      ansible_ssh_pass: "******"
      ansible_python_interpreter: "/usr/bin/python3"
    device2:
      ansible_host: "192.168.0.11"
      ansible_ssh_user: "leo"
      ansible_ssh_private_key_file: "/home/leo/.ssh/id_ed25519"
      ansible_python_interpreter: "/usr/bin/python3"

mygroup:
  hosts:
    device1:
    device2:
```

# Commands

**Version**

```shell
ansible --version
```

**List inventory**

```shell
ansible-inventory --list
```
