CLOUD_PLAYBOOK   ?= hosts/localhost.yml
LINODE_INVENTORY ?= ./files/inventory/linode.py
BEHAT_TAGS_REAL  ?= $(if $(BEHAT_TAGS), '&&$(BEHAT_TAGS)')

.PHONY: linodes-distros

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

features/files/roles/ergonlogic.cloud:
	cd features/files/roles && \
    ln -s ../../.. ergonlogic.cloud

linodes-test: features/files/roles/ergonlogic.cloud
	behat --tags="~wip&&~disabled$(BEHAT_TAGS_REAL)"
	rm features/files/roles/ergonlogic.cloud

linodes-test-wip: features/files/roles/ergonlogic.cloud
	#behat --tags="wip&&~disabled$(BEHAT_TAGS_REAL)"

linodes-test-slow: features/files/roles/ergonlogic.cloud
	ansible-playbook features/files/hosts/test0.yml -e 'confirm=y' -e 'op=linodes'
	ansible-playbook features/files/hosts/test1.yml -e 'confirm=y' -e 'op=linodes'
	ansible-playbook features/files/hosts/test2.yml -e 'confirm=y' -e 'op=linodes'
	rm features/files/roles/ergonlogic.cloud

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

# vi:syntax=makefile
