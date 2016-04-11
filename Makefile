CLOUD_PLAYBOOK   ?= hosts/localhost.yml
LINODE_INVENTORY ?= ./files/inventory/linode.py

.PHONY: distros

help-linodes:
	@echo "make linodes-help"
	@echo "  Print this help message."
	@echo "make linodes-test"
	@echo "  Run Behat tests."
	@echo "make linodes-distros"
	@echo "  Print a list of distributions available on Linode."
	@echo "make linodes-inventory"
	@echo "  Print the Ansible inventory for Linode."
	@echo "make linodes"
	@echo "  Create and manage defined Linode servers."
	@echo "make linodes-destroy"
	@echo "  Destroy all defined Linode servers."

linodes-test:
	behat --tags=~wip

linodes-test-wip:
	behat --tags=wip

linodes-distros: ansible
	ansible-playbook $(CLOUD_PLAYBOOK) -e "op=get_distros"

linodes-inventory:
	$(LINODE_INVENTORY) --refresh-cache

linodes-inventory-quiet:
	$(LINODE_INVENTORY) --refresh-cache > /dev/null

linodes: ansible linodes-inventory-quiet
	ansible-playbook $(CLOUD_PLAYBOOK)

linodes-force: ansible linodes-inventory-quiet
	ansible-playbook $(CLOUD_PLAYBOOK) -e "confirm=y"

linodes-destroy: ansible linodes-inventory-quiet
	LINODE_STATE=absent ansible-playbook $(CLOUD_PLAYBOOK)

linodes-destroy-force: ansible linodes-inventory-quiet
	LINODE_STATE=absent ansible-playbook $(CLOUD_PLAYBOOK) -e "confirm=y"

include .mk/GNUmakefile

# vi:syntax=makefile
