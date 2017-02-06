CLOUD_PLAYBOOK    ?= hosts/localhost.yml
AWS_EC2_INVENTORY ?= inventory/ec2.py
BEHAT_TAGS_REAL   ?= $(if $(BEHAT_TAGS), '&&$(BEHAT_TAGS)')

.PHONY: aws-ec2-inventory

help-aws-ec2:
	@echo "make aws-ec2-inventory"
	@echo "  Print the Ansible inventory for EC2."
	@echo "make aws-ec2"
	@echo "  Create and manage defined EC2 servers."
	@echo "make aws-ec2-destroy"
	@echo "  Destroy all defined EC2 servers."

aws-ec2-test: features/files/roles/ergonlogic.cloud behat
	behat --tags="@aws&&@ec2&&~wip&&~disabled$(BEHAT_TAGS_REAL)"
	rm features/files/roles/ergonlogic.cloud

aws-ec2-test-wip: features/files/roles/ergonlogic.cloud behat
	behat --tags="@aws&&@ec2&&wip&&~disabled$(BEHAT_TAGS_REAL)"
	rm features/files/roles/ergonlogic.cloud

aws-ec2-test-slow: features/files/roles/ergonlogic.cloud
	ansible-playbook features/files/hosts/aws/ec2/test0.yml -i $(AWS_EC2_INVENTORY) -e 'confirm=y' -e 'op=ec2'
	ansible-playbook features/files/hosts/aws/ec2/test1.yml -i $(AWS_EC2_INVENTORY) -e 'confirm=y' -e 'op=ec2'
	ansible-playbook features/files/hosts/aws/ec2/test2.yml -i $(AWS_EC2_INVENTORY) -e 'confirm=y' -e 'op=ec2'
	rm features/files/roles/ergonlogic.cloud

aws-ec2-inventory:
	$(AWS_EC2_INVENTORY) --refresh-cache

aws-ec2-inventory-quiet:
	@$(AWS_EC2_INVENTORY) --refresh-cache > /dev/null

aws-ec2: ansible aws-ec2-inventory-quiet
	ansible-playbook $(CLOUD_PLAYBOOK) -i $(AWS_EC2_INVENTORY)

aws-ec2-force: ansible aws-ec2-inventory-quiet
	ansible-playbook $(CLOUD_PLAYBOOK) -i $(AWS_EC2_INVENTORY) -e "confirm=y"

aws-ec2-destroy: ansible aws-ec2-inventory-quiet
	AWS_EC2_STATE=absent ansible-playbook $(CLOUD_PLAYBOOK) -i $(AWS_EC2_INVENTORY)

aws-ec2-destroy-force: ansible aws-ec2-inventory-quiet
	AWS_EC2_STATE=absent ansible-playbook $(CLOUD_PLAYBOOK) -i $(AWS_EC2_INVENTORY) -e "confirm=y"

# vi:syntax=makefile
