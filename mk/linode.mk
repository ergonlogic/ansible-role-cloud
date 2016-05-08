CLOUD_PLAYBOOK   ?= hosts/localhost.yml
LINODE_INVENTORY ?= inventory/linode.py
BEHAT_TAGS_REAL  ?= $(if $(BEHAT_TAGS), '&&$(BEHAT_TAGS)')

.PHONY: linode-distros linode-inventory

help-linode:
	@echo "make linode-distros"
	@echo "  Print a list of distributions available on Linode."
	@echo "make linode-inventory"
	@echo "  Print the Ansible inventory for Linode."
	@echo "make linode"
	@echo "  Create and manage defined Linode servers."
	@echo "make linode-destroy"
	@echo "  Destroy all defined Linode servers."

features/files/roles/ergonlogic.cloud:
	cd features/files/roles && \
    ln -s ../../.. ergonlogic.cloud

linode-test: features/files/roles/ergonlogic.cloud
	behat --tags="~wip&&~disabled$(BEHAT_TAGS_REAL)"
	rm features/files/roles/ergonlogic.cloud

linode-test-wip: features/files/roles/ergonlogic.cloud
	#behat --tags="wip&&~disabled$(BEHAT_TAGS_REAL)"

linode-test-slow: features/files/roles/ergonlogic.cloud
	ansible-playbook features/files/hosts/test0.yml -e 'confirm=y' -e 'op=linode'
	ansible-playbook features/files/hosts/test1.yml -e 'confirm=y' -e 'op=linode'
	ansible-playbook features/files/hosts/test2.yml -e 'confirm=y' -e 'op=linode'
	rm features/files/roles/ergonlogic.cloud

linode-distros: ansible
	ansible-playbook $(CLOUD_PLAYBOOK) -e "op=get_distros"

linode-inventory:
	$(LINODE_INVENTORY) --refresh-cache

linode-inventory-quiet:
	$(LINODE_INVENTORY) --refresh-cache > /dev/null

linode: ansible linode-inventory-quiet
	ansible-playbook $(CLOUD_PLAYBOOK)

linode-force: ansible linode-inventory-quiet
	ansible-playbook $(CLOUD_PLAYBOOK) -e "confirm=y"

linode-destroy: ansible linode-inventory-quiet
	LINODE_STATE=absent ansible-playbook $(CLOUD_PLAYBOOK)

linode-destroy-force: ansible linode-inventory-quiet
	LINODE_STATE=absent ansible-playbook $(CLOUD_PLAYBOOK) -e "confirm=y"

# vi:syntax=makefile
