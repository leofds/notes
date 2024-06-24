# Ansible

## How to install on Ubuntu 24

Run the script [install.sh](https://github.com/leofds/notes/blob/master/ansible/install.sh) to install ansible v2.17.0 from the official repository [Ansible](https://github.com/ansible/ansible).

## Setup

[doc](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)

Create the `ansible.cfg` file on `/etc/ansible`.

```shell
ansible-config init --disabled -t all > ansible.cfg
sudo install -Dm744 ansible.cfg /etc/ansible/ansible.cfg
sudo chown $USER:$USER -R /etc/ansible
rm ansible.cfg
```
