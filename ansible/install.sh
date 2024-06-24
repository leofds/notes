#!/bin/bash

ANSIBLE_VERSION="v2.17.0"

NEW_PATH="$HOME/.local/bin"
BASHRC_FILE="$HOME/.bashrc"

if ! grep -Fxq "export PATH=\"$NEW_PATH:\$PATH\"" $BASHRC_FILE ; then
	echo "export PATH=\"$NEW_PATH:\$PATH\"" >> $BASHRC_FILE
	source ~/.bashrc
fi

if ! python3 -m pip -V &> /dev/null ; then
	echo "Installing PIP"
	curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
	python3 /tmp/get-pip.py --user --break-system-packages
fi

python3 -m pip install --user "https://github.com/ansible/ansible/archive/refs/tags/${ANSIBLE_VERSION}.tar.gz" --break-system-packages
ansible --version
