#!/bin/bash

ANSIBLE_VERSION="2.17.1"

NEW_PATH="$HOME/.local/bin"
BASHRC_FILE="$HOME/.bashrc"
ANSIBLE_DIR=/etc/ansible

if ! grep -Fxq "export PATH=\"$NEW_PATH:\$PATH\"" $BASHRC_FILE ; then
	echo "export PATH=\"$NEW_PATH:\$PATH\"" >> $BASHRC_FILE
	source "${BASHRC_FILE}"
fi

if ! python3 -m pip -V &> /dev/null ; then
	echo "Installing PIP"
	curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
	python3 /tmp/get-pip.py --user --break-system-packages
fi

# Install Ansible
installed_version=""
if ansible --version &> /dev/null; then
	installed_version=$(ansible --version | awk '/core/{gsub(/[\[\]]/,"",$3); print $3}')	
fi
if [[ "${installed_version}" != "${ANSIBLE_VERSION}" ]]; then
	echo "Installing Ansible ${ANSIBLE_VERSION}"
	python3 -m pip install --user "https://github.com/ansible/ansible/archive/refs/tags/v${ANSIBLE_VERSION}.tar.gz" --break-system-packages
else
	echo "Ansible ${installed_version} already installed"
fi

# Setup
#if [ ! -e "${ANSIBLE_DIR}/ansible.cfg" ]; then
#	echo "Creating configuration file"
#	ansible-config init --disabled -t all > ansible.cfg
#	sudo install -Dm744 ansible.cfg /etc/ansible/ansible.cfg
#	sudo chown $USER:$USER -R /etc/ansible
#	rm ansible.cfg
#fi

ansible --version
