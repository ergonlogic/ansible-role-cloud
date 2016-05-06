CLOUD_PLAYBOOK   ?= features/files/hosts/localhost.yml
LINODE_INVENTORY ?= inventory/linode.py

test: linode-test
test-wip: linode-test-wip

include mk/linode.mk
include .mk/GNUmakefile

# vi:syntax=makefile
