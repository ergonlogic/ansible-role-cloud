CLOUD_PLAYBOOK   ?= features/files/hosts/localhost.yml
LINODE_INVENTORY ?= inventory/linode.py

test: linodes-test
test-wip: linodes-test-wip

include mk/linodes.mk
include .mk/GNUmakefile

# vi:syntax=makefile
