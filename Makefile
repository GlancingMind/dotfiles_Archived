.POSIX:

arch:
	ansible-playbook --ask-become-pass -i inventory/arch setup-hardware.yml

sascha:
	ansible-playbook --ask-become-pass -i inventory/arch setup-sascha.yml
