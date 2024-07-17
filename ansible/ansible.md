
# Summary

1. [Ansible concepts](#ansible_concepts)<br>
2. [How to install on Ubuntu 24](#install_ubuntu24)<br>
  2.1 [Creating configuration file](#creating_conf_file)<br>
  2.2 [Creating inventory (YAML)](#session_1-2)<br>

# Ansible

Ansible is an open source IT automation engine that automates provisioning, configuration management, application deployment, orchestration, and many other IT processes.</br>

Web Page: [https://www.ansible.com/](https://www.ansible.com/)</br>
Documentation: [https://docs.ansible.com/](https://docs.ansible.com/)</br>
GitHub: [https://github.com/ansible/ansible](https://github.com/ansible/ansible)</br>

In brief, Ansible connects to remote hosts via SSH to execute commands or Python scripts previously sent by SCP.

# 1. Ansible concepts <a name="ansible_concepts"></a>

- **Control node (controller)** The machine from which you run the Ansible Commands. Ansible needs to be installed only on this machine.</br>
- **Managed nodes (hosts)** Target devices you aim to manage with Ansible.</br>
- **Inventory** List of hosts and groups.</br>
- **Playbook** A collection of plays. A file coded in YAML.</br>
  - **Play** Run tasks on a host or a collection of hosts.</br>
  - **Taks** Call functions defined as Ansible Modules (coded in Python)</br>
  - **Roles** A reusable Ansible content (tasks, variables, ...) for user inside a Play.</br>
  - **Handlers** Handlers are tasks that only run when notified (when the task returns a ‘changed=True’ status).</br>
- **Variables** Variables store and retrieve values that can be referenced in playbooks, roles, templates and other Ansible components.
- **Vault** Ansible Vault is a feature of ansible that allows you to keep sensitive data such as passwords or keys in encrypted files.
- **Modules** Usually a Python script sent to each host (when needed) to accomplish the action in each Task.</br>
- **Plugins** Expands the Ansible's core capactibilities.</br>
  - **Connection Plugins**</br>
  - **Filter Plugins**</br>
  - **Callback Plugins**</br>
- **Collections** A format in which Ansible content is distributed that can contain playbooks, roles, modules, and plugins. You can install and use collections through [Ansible Galaxy](https://galaxy.ansible.com/ui/).</br>

## 1 How to install on Ubuntu 24 <a name="install_ubuntu24"></a>

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

### 1.1 Creating configuration file <a name="creating_conf_file"></a>

```shell
sudo mkdir -p /etc/ansible
sudo chown $USER:$USER /etc/ansible
ansible-config init --disabled -t all > /etc/ansible/ansible.cfg
```

### 1.2 Creating inventory (YAML) <a name="session_1-2"></a>

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

## 2 Commands <a name="session_2"></a>

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
ansible-playbook myplaybook.yml --vault-password-file pass_file    # vault password file
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

**Vault**

```shell
ansible-vault create myfile.yml                     # Create new vault encrypted file
ansible-vault decrypt myfile.yml                    # Decrypt vault encrypted file
ansible-vault edit myfile.yml                       # Edit vault encrypted file
ansible-vault view myfile.yml                       # View vault encrypted file
ansible-vault encrypt myfile.yml                    # Encrypt YAML file
ansible-vault encrypt_string 'value' --name 'key'   # Encrypt a string
ansible-vault rekey myfile.yml                      # Re-key a vault encrypted file
```

## 3 Inventory

[[doc]](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)

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

## 4 Introducing Playbooks

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

[[doc]](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html)

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
/etc/ansible/group_vars/mygroup   # can optionally end in '.yml', '.yaml', or '.json'
```

**host_vars**

Create the dir `/etc/ansible/host_vars`. 

```shell
/etc/ansible/host_vars/localhost   # Variables file of localhost
```

**Multiple files for a host/group**

Create directories named instead of a file. Ansible will read all the files in these directories.

```yaml
/etc/ansible/group_vars/mygroup/network_settings
/etc/ansible/group_vars/mygroup/cluster_settings
```

### 5.5 Special Variables

[[doc]](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html)

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

[[doc]](https://docs.ansible.com/ansible/latest/reference_appendices/common_return_values.html)

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

# 6 Playbooks

## 6.1 Keywords

[[doc]](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html)

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
  handlers:
  roles:
```

**Play**

```yaml
  tasks:
      notify:                    # List of handlers to notify when the task returns a ‘changed=True’ status.
      ignore_errors:             # Boolean to ignore the task failures and continue with the play.
      failed_when:               # Conditional expression that overrides the task 'failed' status.
      changed_when:              # with true: the task is always resported as changed
```

## 6.2 Tasks

### 6.2.1 Conditionals (when)

[[doc]](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html)

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

### 6.2.2 loops

[[doc]](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html)

### 6.2.2.1 loop

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

#### 6.2.2.2 loop control

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

## 6.3 Blocks

[[doc]](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_blocks.html)

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

### 6.3.1 Handling tasks failures with `rescue`

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

### 6.3.2 `always` section

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

## 6.4 Handlers

[[doc]](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_handlers.html)

Handlers are tasks that only run when notified. Usually when a task made a change in a machine.

```yaml
  tasks:
    - name: Install service
      # ...
      notify:
        - Restart service

  handlers:
    - name: Restart service
      # ...
```

## 6.5 Re-using Ansible artifacts

[[doc]](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse.html)

```yaml
- import_playbook: myplaybook1.yml
- import_playbook: myplaybook1.yml
```

# 7 Roles

[[doc]](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html)

Roles are a reusable Ansible content (tasks, variables, ...) for user inside a Play.

An Ansible role has a defined directory structure with seven main standard directories. You must include at least one of these directories in each role. You can omit any directories the role does not use.

```
roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  <-- files for use with the template resource
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables associated with this role
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role
        meta/             #
            main.yml      #  <-- role dependencies
        library/          # roles can also include custom modules
        module_utils/     # roles can also include custom module_utils
        lookup_plugins/   # or other types of plugins, like lookup in this case
```

Default locations:
- in collections, if you are using them
- in a directory called roles/, relative to the playbook file
- in the configured roles_path. The default search path is `~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles`.
- in the directory where the playbook file is located

You can store the roles in a different location settings `roles_path` in the ansible.cfg

## 7.1 Creating a role (task)

`/etc/ansible/roles/example/tasks/main.yml`

```yaml
- name: Install service
  # ....
```

## 7.2 Using roles

## 7.2.1 Play level

Roles in the session roles run before any other tasks in a play.

```yaml
- hosts: all
  roles:
    - role: '/etc/ansible/roles/example'
```

```yaml
- hosts: all
  roles:
    - example
    - common:
      vars:
        dir: '/opt/a'
        app_port: 5000
```

## 7.2.2 Task level

**Including roles: dynamic use**

The roles in tasks run in the order they are defined. Variables can be defined in the runtime.

```yaml
- hosts: all
  tasks:
    - name: Include the example role
      include_role:
        name: example
```

**Including roles: static use**

The behavior is the same as using the roles keyword.

```yaml
- hosts: all
  tasks:
    - name: Import the example role
      import_role:
        name: example
```

# 8 Vault

[[doc]](https://docs.ansible.com/ansible/latest/vault_guide/index.html)

Ansible Vault is a feature of Ansible that allows you to keep sensitive data such as passwords or keys in encrypted files or variables, it can encrypt any data file used by Ansible. To use Ansible Vault you need one or more passwords to encrypt or decrypt content.

The command to use Ansible Vault is `ansible-vault` and the available arguments are `create,decrypt,edit,view,encrypt,encrypt_string,rekey`.

## 8.1 Vault Password

Running any `ansible-vault` command or a playbook that uses some encrypted content, you will prompted for a password.

The vault password can be stored:
- In a file:
  - Adding the argument `--vault-password-file /path/to/vault_password` to the command line.
  - Setting the file path in the ansible.cfg file updating the entry `vault_password_file=`.
  - Setting the file path in the environment variable `ANSIBLE_VAULT_PASSWORD_FILE`.
- In third-party tools with client scripts.
  - `ansible-playbook --vault-password-file client.py`
  - `ansible-playbook --vault-id dev@client.py`

To enforce password prompt, add the argument `--ask-vault-pass` to the command line.

## 8.2 Variable-level encryption

Variable-level encryption only works with variables and keeps your files still legible. You can mix plaintext and encrypted variables. However, password rotation is not possible to do with the `rekey` command.

### 8.2.1 Encrypting variables

**Example**: Encrypting the string '1234' using the variable name 'my_secret'

Command:

```yaml
ansible-vault encrypt_string '1234' --name 'my_secret'
```

Output:

```yaml
my_secret: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          30656465653266303161616131336562316661656331356231633330343131626264643864313335
          3031656537383066363337383964646462383938336630650a626330633762356266313366373464
          62386332653766316462343530323832303432353738313265633766653263633035313034313963
          3138613132386239660a383365393161323363383061353866656639633732326465336261646662
          6239
```

### 8.2.1 Viewing encrypted variables

You can view the original value using the debug module.

Command:

```yaml
ansible localhost -m ansible.builtin.debug -a var="my_secret" -e "@variables.yml" --ask-vault-pass
```

Output:

```yaml
localhost | SUCCESS => {
    "my_secret": "1234"
}
```

## 8.3 File-level encryption 

File-level encryption is easy to use, encrypting variables, tasks, or other Ansible content files. It also allows password rotation with `rekey`, but all the file content will be encrypted, you will not 
be able to read the variable name without decrypting it for instance. 

### 8.3.1 Encrypting files

Variable file content (variables.yml):
```yaml
username: 'leo'
password: '1234'
```

Command:
```yaml
ansible-vault encrypt variables.yml      # Encrypt an existing file
ansible-vault create variables.yml       # Optionaly this command open a text editor creating a new encrypted file
```

Encrypted file content:
```yaml
$ANSIBLE_VAULT;1.1;AES256
61663463663838653230363163373233323739663930396238346462666466663332373334396537
3932623330646639653130316530353937666634643638350a616238653639363334623437353337
33306234353239656264643633613938316537626237653264383161326635623962383630383363
3064383438663031630a663963333937393464326335356666323733366230313531613431336135
61373930343333303665363532656634376339373637626466353436626633343863313566323665
3166353736346239346166346166393530373532616231343530
```

### 8.3.2 Decrypting files

```yaml
ansible-vault decrypt variables.yml      # Decrypt the entire file
ansible-vault view variables.yml         # View the content decrypted
ansible-vault edit variables.yml         # Open a editor to edit the 
```

### 8.3.2 Rotating password

```yaml
ansible-vault rekey variables.yml        # Change the ecryption key
```

# 9 Modules

# 10 Plugins

## 10.1 Connection Plugins

## 10.2 Filter Plugins

## 10.3 Callback Plugins

# 11 Collections

# Template