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

linode-test: features/files/roles/ergonlogic.cloud
	behat --tags="@linode&&~wip&&~disabled$(BEHAT_TAGS_REAL)" --stop-on-failure
	rm features/files/roles/ergonlogic.cloud

linode-test-wip: features/files/roles/ergonlogic.cloud
	#behat --tags="@linode&&wip&&~disabled$(BEHAT_TAGS_REAL)"

linode-test-slow: features/files/roles/ergonlogic.cloud generate-keypair
	ansible-playbook features/files/hosts/linode/test0.yml -i $(LINODE_INVENTORY)
	ansible-playbook features/files/hosts/linode/test1.yml -i $(LINODE_INVENTORY)
	ansible-playbook features/files/hosts/linode/test2.yml -i $(LINODE_INVENTORY)
	rm features/files/roles/ergonlogic.cloud

linode-distros: ansible
	ansible-playbook features/files/hosts/linode/distros.yml -i inventory/localhost.yml

linode-inventory:
	$(LINODE_INVENTORY) --refresh-cache

linode-inventory-quiet:
	$(LINODE_INVENTORY) --refresh-cache > /dev/null

linode: ansible linode-inventory-quiet
	ansible-playbook $(CLOUD_PLAYBOOK) -i $(LINODE_INVENTORY)

linode-destroy: ansible linode-inventory-quiet
	LINODE_STATE=absent ansible-playbook $(CLOUD_PLAYBOOK) -i $(LINODE_INVENTORY)

# vi:syntax=makefile
