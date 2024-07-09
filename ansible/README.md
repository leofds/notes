# Ansible

Ansible is an open source IT automation engine that automates provisioning, configuration management, application deployment, orchestration, and many other IT processes.</br>[https://www.ansible.com/](https://www.ansible.com/)</br>

In brief, Ansible connects to remote hosts via SSH to execute commands or Python scripts previously sent by scp.

## Ansible concepts

- **Control node (controller)** The machine from which you run the Ansible Commands. Ansible needs to be installed only on this machine.</br>
- **Managed nodes (hosts)** Target devices you aim to manage with Ansible.</br>
- **Inventory** List of hosts.</br>
- **Playbook** A collection of plays. A file coded in YAML.</br>
  - **Play** Run tasks on a host or a collection of hosts.</br>
  - **Taks** Call functions defined as Ansible Modules (coded in Python)</br>
  - **Roles** A reusable Ansible content (tasks, variables, ...) for user inside a Play.</br>
  - **Handlers** Handlers are tasks that only run when notified (when the task returns a ‘changed=True’ status).</br>
- **Modules** Usually a Python script sent to each host (when needed) to accomplish the action in each Task.</br>
- **Plugins** Expands the Ansible's core capactibilities.</br>
  - **Connection Plugins**</br>
  - **Filter Plugins**</br>
  - **Callback Plugins**</br>
- **Collections** A format in which Ansible content is distributed that can contain playbooks, roles, modules, and plugins. You can install and use collections through [Ansible Galaxy](https://galaxy.ansible.com/ui/).</br>

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

### 1.1. Creating configuration file

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
    device2:
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
ansible-playbook myplaybook.yml --check                  # Check mode is just a simulation

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



**Sample Playbook file (myplaybook.yml)**

```yaml
- name: Sample Playbook
  hosts: all

  tasks:
    - name: Display a debug message
      debug:
        msg: "Hello Admin"
```
Running the playbook on localhost (if localhost is in the inventory)

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

Ansible uses `Jinja2` to access variables dynamically using `{{ variable_name }}`.

```yaml
...
- name: Display a debug message
  debug:
    msg: "Hello {{ username }}"
```

### 4.1. Variable types

**Simple variable**

```yaml
base_path: '/etc/config'
```
Referencing a simple variable
```yaml
app_path: "{{ base_path }}"
```

**Multiple lines string**

```yaml
message: >
  Your long
  string here.
```

```yaml
message: |
  this is a very
  long string
```

**List**

```yaml
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

  tasks:
    - name: Display a debug message
      vars:
        username: 'leo'
```

### 4.3. External Variables file (.yml)

```yml
username: 'leo'
password: '*****'
```

### 4.4. Inventory Variables

```yaml
mygroup:
  hosts:
    device1:
      username: "leo"       # host variable
  vars:
    dummy: "superserver"    # group variable
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

### 4.5. Special Variables

[doc](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html)

```yaml
ansible_host: "192.168.0.10"
ansible_ssh_user: "leo"
ansible_ssh_pass: "******"
ansible_ssh_private_key_file: "/home/leo/.ssh/id_ed25519"
ansible_python_interpreter: "/usr/bin/python3"
```

# 5. Writing Playbooks

## 5.1. Playbook keywords

[doc](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html)

- Play
- Role
- Block
- Task

**Play**

```yaml
- name: Sample

  hosts: <pattern>          # Common patterns (they can be combined)
                            # all - All hosts
                            # host1 - One host
                            # host1:host2 (host1,host2) - Multiple hosts/groups
                            # all:!host1 - All hosts/groups except one
                            # group1:&group2 - Any hosts in the group1 that are also in the group2

  gather_facts: false       # Disable facts to improve performance (default true)

  connection: <plugin>      # Change the connection plugin. Lists available plugins with `ansible-doc -t connection -l`.
                            # ssh - connect via ssh client binary (default)
                            # local - execute on controller

  collections:              # Using a collection.
    - my_namespace.my_collection

  become: yes               # Ansible allows you to ‘become’ another user, different from the user that logged into the machine (remote user).
                            # This is done using existing privilege escalation tools such as sudo, su, pfexec, doas, pbrun, dzdo, ksu, runas, machinectl and others.
  become_method: su
  become_user: nobody       # default root
  become_pass:
  become_flags: '-s /bin/sh'

  service:                   # Controls services on remote hosts. Ensure the httpd service is running
    name: httpd
    state: started



  timeout:                   # Time limit for the task to execute in, if exceeded Ansible will interrupt and fail the task.

  command:

  vars:                      # Dictionary/map of variables
    username: 'leo'

  vars_files:                # List of files that contain vars to include in the play.
    - /vars/external_vars.yml

  vars_prompt:                         # list of variables to prompt for
    - name: username                   # variable name
        prompt: What is your username? # prompt message
        private: false                 # makes the user input visible (hidden by default)
        default: "1.0"                 # default value
        confirm: true                  # request confirmation
        encrypt: sha512_crypt          # encript. (use private = true)
        unsafe: true                   # allow special chars
        salt_size: 7

  block:
  tasks:
      notify:                    # List of handlers to notify when the task returns a ‘changed=True’ status.

  roles:
```

**ansible_facts**

Ansible facts are data related to your remote systems.
By default, Ansible gathers facts at the beginning of each play.

```yaml
- name: Print all available facts
  debug:
    var: ansible_facts
```
