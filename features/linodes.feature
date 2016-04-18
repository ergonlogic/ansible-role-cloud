Feature: Deploy and manage servers on Linode
  In order to automate infrastructure deployment
  As a DevOps engineer
  I need to be able to easily work with the Linode API

  Scenario: Get a list of Linode distributions and their IDs
     When I run "make linodes-distros"
     Then I should get:
       """
       ansible-playbook features/files/hosts/localhost.yml -e "op=get_distros"
       124: Ubuntu 14.04 LTS
       140: Debian 8
       """

  Scenario: Call a command to ensure the proper state of all defined linodes.
     When I run "make linodes-force --dry-run"
     Then I should get:
       """
       inventory/linode.py --refresh-cache > /dev/null
       ansible-playbook features/files/hosts/localhost.yml -e "confirm=y"
       """
      And I run "ansible-playbook features/files/hosts/localhost.yml -e'confirm=y' --check"
     Then I should get:
       """
       TASK [ergonlogic.cloud : Include 'get_distros' tasks] **************************
       skipping: [localhost]

       TASK [ergonlogic.cloud : Include 'inventory' tasks] ****************************
       skipping: [localhost]

       TASK [ergonlogic.cloud : Check environment for LINODE_STATE] *******************
       ok: [localhost]

       TASK [ergonlogic.cloud : Include tasks to create missing linodes] **************
       skipping: [localhost]

       TASK [ergonlogic.cloud : Include tasks to ensure the proper state and group of linodes] ***
       skipping: [localhost]
       """

  Scenario: Call a command to destroy all defined linodes.
     When I run "make linodes-destroy-force --dry-run"
     Then I should get:
       """
       inventory/linode.py --refresh-cache > /dev/null
       LINODE_STATE=absent ansible-playbook features/files/hosts/localhost.yml -e "confirm=y"
       """
      And I run "inventory/linode.py --refresh-cache > /dev/null"
      And I run "LINODE_STATE=absent ansible-playbook features/files/hosts/localhost.yml -e'confirm=y' --check"
     Then I should get:
       """
       TASK [ergonlogic.cloud : Include 'get_distros' tasks] **************************
       skipping: [localhost]

       TASK [ergonlogic.cloud : Include 'inventory' tasks] ****************************
       skipping: [localhost]

       TASK [ergonlogic.cloud : Check environment for LINODE_STATE] *******************
       ok: [localhost]

       TASK [ergonlogic.cloud : Include tasks to create missing linodes] **************
       skipping: [localhost]

       TASK [ergonlogic.cloud : Include tasks to ensure the proper state and group of linodes] ***
       skipping: [localhost]
       """

