CLOUD_PLAYBOOK   ?= features/files/hosts/localhost.yml
LINODE_INVENTORY ?= inventory/linode.py

ansible_RELEASE   = v2.2.1.0-1

cloud-init:
	pip install --user boto

test: linode-test
test-wip: linode-test-wip

features/files/roles/ergonlogic.cloud:
	cd features/files/roles && ln -s ../../.. ergonlogic.cloud

include mk/linode.mk
include mk/aws/ec2.mk
include .mk/GNUmakefile

# vi:syntax=makefile
