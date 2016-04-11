Feature: Deploy and manage servers on Linode
  In order to automate infrastructure deployment
  As a DevOps engineer
  I need to be able to easily work with the Linode API

  Scenario: Get a list of Linode distributions and their IDs
     When I run "make distros"
     Then I should get:
       """
       ansible-playbook tasks/get_distros.yml
       124: Ubuntu 14.04 LTS
       140: Debian 8
       localhost                  : ok=4    changed=0    unreachable=0    failed=0
       """

  Scenario: Create a Linode server
     When I run "make create --dry-run"
     Then I should get:
       """
       ansible-playbook tasks/create.yml
       """
      And I run "ansible-playbook tasks/create.yml -e'confirm_create=y' --check"
     Then I should get:
       """
       PLAY [localhost] ***************************************************************

       TASK [linode] ******************************************************************

       PLAY RECAP *********************************************************************
       localhost                  : ok=0    changed=0    unreachable=0    failed=0   
       """

  Scenario: Destroy a Linode server
     When I run "make destroy --dry-run"
     Then I should get:
       """
       ansible-playbook tasks/destroy.yml
       """
      And I run "ansible-playbook tasks/destroy.yml -e'confirm_destroy=y' --check"
     Then I should get:
       """
       PLAY [localhost] ***************************************************************

       TASK [linode] ******************************************************************

       PLAY RECAP *********************************************************************
       localhost                  : ok=0    changed=0    unreachable=0    failed=0   
       """


