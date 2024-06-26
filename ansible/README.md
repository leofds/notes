# Ansible

## 1. How to install on Ubuntu 24

```shell
sudo apt update
sudo apt install pipx -y
pipx install --include-deps ansible
pipx ensurepath
source ~/.bashrc
```

Updating

```shell
pipx upgrade --include-injected ansible
```

### 1.1. Creating configuration file (optional)

```shell
sudo mkdir -p /etc/ansible
sudo chown $USER:$USER /etc/ansible
ansible-config init --disabled -t all > /etc/ansible/ansible.cfg
```

### 1.2. Creating inventory (YAML)

```shell
touch /etc/ansible/hosts
```


```yaml
mygroup:
  hosts:
    device1:
      ansible_host: "192.168.0.10"
      ansible_ssh_user: "leo"
      ansible_ssh_pass: "******"
    device2:
      ansible_host: "192.168.0.11"
      ansible_ssh_user: "leo"
      ansible_ssh_private_key_file: "/home/leo/.ssh/id_ed25519"
  vars:
    ansible_python_interpreter: "/usr/bin/python3"
```

## 2. Commands

**Version**

```shell
ansible --version
```

**Show inventory**

```shell
ansible-inventory --list
```

**Run Playbook**

```shell
# General
ansible-playbook myplaybook.yml                          # run the playbook for all hosts defined inside the playbook
ansible-playbook myplaybook.yml -l localhost,device1     # (--limit) limit selected hosts (comma separated)
ansible-playbook myplaybook.yml -i /tmp/inventory.yml    # (--inventory) specify the inventory (comma separated)
ansible-playbook myplaybook.yml -vvv                     # verbose mode (-v, -vvv, -vvvv)

# Extra variables at runtime
ansible-playbook myplaybook.yml -e username=leo                   # (--extra_vars) set additional variables as key=value or YAML/JSON
ansible-playbook myplaybook.yml -e "username=leo password=*****"  # Multiples key=value
ansible-playbook myplaybook.yml -e '{"username":"leo"}'           # inline JSON
ansible-playbook myplaybook.yml -e @/var/external_vars.yml        # if filename prepend with @

# Tags and Tasks
ansible-playbook myplaybook.yml --list-tags              # list all available tags
ansible-playbook myplaybook.yml --list-tasks             # list all tasks that would be executed
ansible-playbook myplaybook.yml --tags                   # (-t) only run plays and tasks tagged with these values
ansible-playbook myplaybook.yml --skip-tags              # only run plays and tasks whose tags do not match these values

# Vault pass
ansible-playbook myplaybook.yml --ask-vault-pass         # ask for vault password
ansible-playbook myplaybook.yml --vault-password-file    # vault password file
```

**Run Module**

```shell
ansible localhost -m ping                                 # connection test            
ansible localhost -m setup --tree facts.d/                # write facts to file
```

**Installing collections with Ansible Galaxy**

```shell
ansible-galaxy collection install ansible.utils           # Install the collection ansible.utils
```

## 3. Playbook

Ansible Playbook File is a lists of tasks that executes for specified inventory.

**Sample Playbook file (myplaybook.yml)**

```yaml
- name: Sample Playbook
  hosts: all

  tasks:
    - name: Display a debug message
      debug:
        msg: "Hello Admin"
```

```shell
ansible-playbook myplaybook.yml -l localhost
```

**output**
```

PLAY [Sample PLaybook] ***********************************************************************************************************************************************

TASK [Display a debug message] ***************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Welcome Admin"
}

PLAY RECAP ***********************************************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## 4. Variables

Ansible uses `Jinja2` to access variables dynamically (`{{ variable_name }}`).

```yaml
...
- name: Display a debug message
  debug:
    msg: "Hello {{ username }}"
```

### 4.1. Variable types

**Simple variable**

```yaml
vars:
  base_path: '/etc/config'
```
Referencing simple variables
```yaml
app_path: "{{ base_path }}"
```

**Multiple lines string**

```yaml
vars:
  message: >
    Your long
    string here.
```

```yaml
vars:
  message: |
    this is a very
    long string
```

**List**

```yaml
vars:
  region:
  - northeast
  - southeast
  - midwest
```
Referencing list variables
```yaml
region: "{{ region[0] }}"
```

**Dictionary**

```yaml
var:
  foo:
    field1: one
    field2: two
```
Referencing key:value dictionary variables
```yaml
field: "{{ foo['field1'] }}"
field: "{{ foo.field1 }}"
```

### 4.2. Variables in the Playbook file (.yml)

```yml
- name: Sample Playbook
  hosts: all
  vars:
    username: 'leo'
    password: '*****'
  vars_files:
    - /vars/external_vars.yml
```

### 4.3. External Variables file (.yml)

```yml
username: 'leo'
password: '*****'
```

### 4.4. group_vars & host_vars

group_vars/host_vars variables files are automatically loaded when running a playbook. 

**group_vars**

Create the dir `/etc/ansible/group_vars`. 

```shell
/etc/ansible/group_vars/all.yml       # Variables fiel of all groups
/etc/ansible/group_vars/mygroup.yml   # Variables fiel of the group called mygroups
```

**host_vars**

Create the dir `/etc/ansible/host_vars`. 

```shell
/etc/ansible/host_vars/all.yml         # Variables fiel of all hosts
/etc/ansible/host_vars/localhost.yml   # Variables fiel of the host called localhost
```

### 4.5. Inventory Variables

```yaml
mygroup:
  hosts:
    device1:
      username: "leo"       # host variable
  vars:
    dummy: "superserver"    # group variable
```