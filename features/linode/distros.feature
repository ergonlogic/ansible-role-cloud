@linode @distros
Feature: Get a list of distributions available on Linode
  In order to write infrastructure deployment manifests for Linode
  As a DevOps engineer
  I need to be able to easily list the available distributions

  Scenario: Get a list of Linode distributions and their IDs
     When I run "make linode-distros"
     Then I should get:
       """
       ansible-playbook features/files/hosts/linode/distros.yml -i inventory/localhost.yml
       124: Ubuntu 14.04 LTS
       140: Debian 8
       """
