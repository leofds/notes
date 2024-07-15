# Ansible

Ansible is an open source IT automation engine that automates provisioning, configuration management, application deployment, orchestration, and many other IT processes.</br>[https://www.ansible.com/](https://www.ansible.com/)</br>

In brief, Ansible connects to remote hosts via SSH to execute commands or Python scripts previously sent by SCP.

## Ansible concepts

- **Control node (controller)** The machine from which you run the Ansible Commands. Ansible needs to be installed only on this machine.</br>
- **Managed nodes (hosts)** Target devices you aim to manage with Ansible.</br>
- **Inventory** List of hosts and groups.</br>
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

## 1 How to install on Ubuntu 24

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

### 1.1 Creating configuration file

```shell
sudo mkdir -p /etc/ansible
sudo chown $USER:$USER /etc/ansible
ansible-config init --disabled -t all > /etc/ansible/ansible.cfg
```

### 1.2 Creating inventory (YAML)

```shell
touch /etc/ansible/hosts
```

Example for localhost and one remote host called device1.

```yaml
all:
  hosts:
    localhost:
      ansible_connection: local
    device1:
      ansible_host: "192.168.0.10"
      ansible_ssh_user: "leo"
      ansible_ssh_private_key_file: "/home/leo/.ssh/id_ed25519"
  vars:
    ansible_python_interpreter: "/usr/bin/python3"
```

## 2 Commands

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
ansible-playbook p1.yml p2.yml                           # running multiple playbooks
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
ansible-galaxy collection list                            # List installed collections
```

## 3 Inventory

The default location for this file is `/etc/ansible/hosts`. You can specify a different inventory file at the command line using the -i \<path\> option or in the ansible.cfg file updating the entry `inventory=`.

The most common inventory file formats are INI and YAML (preffered).

Ansible has two special groups, `all` and `ungrouped`. The `all` group contains every host. The `ungrouped` group contains all hosts that don't have another group aside from `all`.

### 3.1 Adding Hosts

In the inventory file add the host name to a group in the `hosts:` session, eding with `:`.

```yaml
all:
  hosts:
    device1:    # host name
    device2:    # host name
```

### 3.2 Adding Groups

In the inventory file add the group name ending with `:`.

```yaml
my_group1:      # group name
  hosts:        # hosts of the group
```

Add to this group the session `hosts:` to specify hosts and the session `children:` to specify other groups as child of this group.

```yaml
my_group3:      # group name
  hosts:        # hosts of the group
  children:     # groups of the group
    my_group1:
    my_group2:
```

## 4 Playbook

### Execution

- A playbook runs in order from top to bottom, by default, each taks one at a time, against all machines of hosts in parallel. After executed on all target machines, Ansible moves on to the next task. If a task fail on a host, Ansible takes that host out of the rotation for the rest of the playbook.

**Sample Playbook file (myplaybook.yml)**

```yaml
- name: Sample Playbook
  hosts: all
  gather_facts: false     # Disable facts (optional)

  tasks:
    - name: Display a debug message
      debug:
        msg: "Hello Admin"
```
Running the playbook on device1 (if device1 is in the inventory)

```shell
ansible-playbook myplaybook.yml -l device1
```

**output**
```

PLAY [Sample PLaybook] ***********************************************************************************************************************************************

TASK [Display a debug message] ***************************************************************************************************************************************
ok: [device1] => {
    "msg": "Welcome Admin"
}

PLAY RECAP ***********************************************************************************************************************************************************
device1                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

### 4.1 Runnig playbook locally (localhost)

Set the connection plugin to `local` (prefered) or exchange the SSH key locally. (`cat "${HOME}/.ssh/id_ed25519.pub" >> "${HOME}/.ssh/authorized_keys"`)

## 5 Variables

Ansible uses `Jinja2` to access variables dynamically using `{{ variable_name }}`.

```yaml
...
- name: Display a debug message
  debug:
    msg: "Hello {{ username }}"
```

### 5.1 Variable types

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

### 5.2 Variables in the Playbook file (.yml)

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

### 5.3 External Variables file (.yml)

```yml
username: 'leo'
password: '*****'
```

### 5.4 Inventory Variables

```yaml
mygroup:
  hosts:
    device1:
      username: "leo"       # host variable
  vars:
    dummy: "superserver"    # group variable
```

### 5.4 group_vars & host_vars

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

### 5.5 Special Variables

[doc](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html)

```yaml
ansible_host: "192.168.0.10"
ansible_ssh_user: "leo"
ansible_ssh_pass: "******"
ansible_ssh_private_key_file: "/home/leo/.ssh/id_ed25519"
ansible_python_interpreter: "/usr/bin/python3"
```

### 5.6 Ansible Facts

Ansible facts are data related to your remote systems.
By default, Ansible gathers facts at the beginning of each play.

```yaml
- name: Print all available facts
  debug:
    var: ansible_facts
```

## 5.6 Registering variables

[docs](https://docs.ansible.com/ansible/latest/reference_appendices/common_return_values.html)

A variable can be created from the Task output with the keyword `register`.

```yaml
- hosts: all
  tasks:
    - name: Runs a shell command registering the output to a variable
      shell: whoami
      register: result

    - name: Reads the variable
      debug:
        msg: "Output: {{ result.stdout }}, return code: {{ result.rc }}"
```

# 6 Playbook keywords

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
      ignore_errors:             # Boolean to ignore the task failures and continue with the play.
      failed_when:               # Conditional expression that overrides the task 'failed' status.

  roles:
```

# 7 tasks

## 7.1 Conditionals (when)

[docs](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html)

Similar to `if`. The code below skipes the task.

```yaml
- name: Sample
  hosts: localhost
  vars:
    value: false

  tasks:
    - name: Test
      debug:
        msg: "Value is true"
      when: value
```

**Logic operators**

```yaml
when: status == "enabled"
when: status != "enabled"
when: status > 5
when: contents.stdout == ""
when: version | int >= 4
when: temperature | float > 90
when: epic or monumental | bool
when: not epic
when: contents.stdout.find('hi') != -1
when: contents.rc == 127
when: result is failed
when: result is succeeded
when: result is skipped
when: result is changed
when: foo is defined
when: bar is undefined
when: x is not defined
```

**Boolean operators AND/OR**

```yaml
when:
  ansible_facts['distribution'] == "Ubuntu" and ansible_facts['distribution_major_version'] == "24"

when:
  - ansible_facts['distribution'] == "Ubuntu"
  - ansible_facts['distribution_major_version'] == "24"
```

```yaml
when: value == "10" or value == "5"
```

```yaml
when: (name == "leo" and version == "5") or
      (name == "admin" and version == "6")
```

## 7.2 loops

[docs](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html)

### 7.2.1 loop

**Simple list**

The `loop` will run the task once per list item.

```yaml
  tasks:
    - name: Test
      debug:
        msg: "Fruit is {{ item }}"
      loop:
        - banana
        - apple
        - orange
```

`with_list` keyword is equivalent to `loop`.

```yaml
      with_list:
        - banana
        - apple
        - orange
```

**Variables**

```yaml
loop: "{{ list_of_fruits }}"
loop: "{{ ['banana', 'apple', 'orange'] }}"
```

**Subkeys**

```yaml
  tasks:
    - name: Test
      debug:
        msg: "User {{ item.name }}"
      loop:
        - { name: 'user1', group: 'root' }
        - { name: 'user2', group: 'local' }
```

**Dictionary**

```yaml
  tasks:
    - name: Test
      vars:
        user_data:
          name: 'leo'
          group: 'root'
      debug:
        msg: "User {{ item.key }} = {{ item.value }}"
      loop: "{{ user_data | dict2items }}"
```

### 7.2.2 loop control

**Until condition**

```yaml
  tasks:
    - name: Test
      shell: /usr/bin/foo
      register: result
      until: result.stdout.find("all systems go") != -1
      retries: 3
      delay: 1
```

# 8 Blocks

[docs](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_blocks.html)

A block is a group of tasks. All taks in the block inherit the block directives.

```yaml
  tasks:
    - name: Install, Setup, Start
      block:
        - name: Install
          # ...
        - name: Setup
          # ...
        - name: Start
          # ...
      when: ansible_facts['distribution'] == 'Ubuntu'
```

## 8.1 Handling tasks failures with `rescue`

Similar to exception handling in many programming languages, `rescue` block specify tasks to run when a task in the block fails.

```yaml
  tasks:
    - name: Handle the error
      block:
        - name: Some command
          # ...
      rescue:
        - name: Print errors
          debug:
            msg: 'Error'
```

## 8.2 `always` section

No matter what the task status in the block is, the tasks in the sessions `always` are always executed after the block tasks.

```yaml
  tasks:
    - name: Always do
      block:
        - name: Some command
          # ...
      always:
        - name: Always do this
          debug:
            msg: 'This always executes'
```