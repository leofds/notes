# Common Modules

Back to [Ansible](https://github.com/leofds/notes/tree/master/ansible/ansible.md)

> **_NOTE:_** Prefer to use a Fully Qualified Collection Name (FQCN) like `ansible.builtin.debug` instead of `debug`, for linking with module documentation and to avoid conflicts with the other collections that may have the same module name.

# Summary

1. [Debug](#debug)
2. [Shell](#shell)
3. [Stat](#stat)
4. [Copy](#copy)
5. [File](#file)
6. [URI](#uri)

# 1. Debug <a name="debug"></a>

[[doc]](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/debug_module.html)

This module prints variables or expressions.

```yaml
- name: Print the content of the variable username
  ansible.builtin.debug:
    msg: User {{ username }}
```

```yaml
- name: Print return information from the previous task
  ansible.builtin.debug:
    var: result
    verbosity: 2
```

# 2. Shell <a name="shell"></a>

[[doc]](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html)

This module runs the command through a shell (/bin/sh) on the remote node.

```yaml
- name: Get uptime information
  ansible.builtin.shell: /usr/bin/uptime
  register: result
```

# 3. Stat <a name="stat"></a>

[[doc]](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/stat_module.html)

Retrieves facts for a file similar to the Linux/Unix ‘stat’ command.

```yaml
- name: Get stats of a file
  ansible.builtin.stat:
    path: /etc/foo.conf
  register: st

- name: Debug
  ansible.builtin.debug:
    var: st.stat
```

<details>

<summary>Debug output</summary>

```json
ok: [localhost] => {
    "st.stat": {
        "atime": 1721699571.7296615,
        "attr_flags": "",
        "attributes": [],
        "block_size": 4096,
        "blocks": 0,
        "charset": "us-ascii",
        "checksum": "f572d396fae9206628714fb2ce00f72e94f2258f",
        "ctime": 1721699571.7296615,
        "dev": 2,
        "device_type": 0,
        "executable": false,
        "exists": true,
        "gid": 1000,
        "gr_name": "leo",
        "inode": 10133099162624209,
        "isblk": false,
        "ischr": false,
        "isdir": false,
        "isfifo": false,
        "isgid": false,
        "islnk": false,
        "isreg": true,
        "issock": false,
        "isuid": false,
        "mimetype": "text/plain",
        "mode": "0644",
        "mtime": 1721699571.7296615,
        "nlink": 1,
        "path": "/home/leo/foo.conf",
        "pw_name": "leo",
        "readable": true,
        "rgrp": true,
        "roth": true,
        "rusr": true,
        "size": 6,
        "uid": 1000,
        "version": null,
        "wgrp": false,
        "woth": false,
        "writeable": true,
        "wusr": true,
        "xgrp": false,
        "xoth": false,
        "xusr": false
    }
}
```

</details>

</br>

Checking if the file exists

```yaml
- name: Check if the file not exists
  ansible.builtin.debug:
    msg: 'Not exist'
  when: not st.stat.exists
```

# 4. Copy <a name="copy"></a>

[[doc]](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html)

This module copies a file or a directory structure from the local or remote machine to a location on the remote machine.

```yaml
- name: Copy file from the controller to remote with owner and permissions
  ansible.builtin.copy:
    src: /srv/myfiles/foo.conf
    dest: /etc/foo.conf
    owner: foo
    group: foo
    mode: '0644'

- name: Copy file on the remote
  ansible.builtin.copy:
    src: /tmp/foo.conf
    dest: /etc/foo.conf
    owner: foo
    group: foo
    mode: '0644'
    remote_src: yes
```

# 5. File <a name="file"></a>

[[doc]](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html)

Set attributes of files, directories, or symlinks and their targets. Alternatively, remove files, symlinks or directories.

```yaml
- name: Create a directory if it does not exist
  ansible.builtin.file:
    path: /etc/some_directory
    owner: root
    group: root
    mode: '0755'
    state: directory

- name: Create a symbolic link
  ansible.builtin.file:
    src: /file/to/link/to
    dest: /path/to/symlink
    owner: foo
    group: foo
    state: link

- name: Change file ownership, group and permissions
  ansible.builtin.file:
    path: /etc/foo.conf
    owner: foo
    group: foo
    mode: '0644'

- name: Recursively change ownership of a directory
  ansible.builtin.file:
    path: /etc/foo
    state: directory
    recurse: yes
    owner: foo
    group: foo

- name: Remove file (delete file)
  ansible.builtin.file:
    path: /etc/foo.txt
    state: absent

- name: Recursively remove directory
  ansible.builtin.file:
    path: /etc/foo
    state: absent
```

# 6. URI <a name="uri"></a>

[[doc]](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/uri_module.html)

Interacts with HTTP and HTTPS web services and supports Digest, Basic and WSSE HTTP authentication mechanisms

```yaml
- name: Retry combined with a loop
  uri:
    url: "https://{{ item }}.ansible.com"
    method: GET
  register: uri_output
  with_items:
  - "galaxy"
  - "docs"
  - "forum"
  - "www"
  retries: 2
  delay: 1
  until: "uri_output.status == 200"

- name: Show the output
  debug:
    msg: "{{ uri_output }}"
```