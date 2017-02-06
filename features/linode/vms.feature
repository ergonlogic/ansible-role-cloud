@linode
Feature: Deploy and manage servers on Linode
  In order to automate infrastructure deployment
  As a DevOps engineer
  I need to be able to easily work with the Linode API

  Scenario: Call a command to ensure the proper state of all defined Linode VMs.
     When I run "make linode --dry-run"
     Then I should get:
       """
       inventory/linode.py --refresh-cache > /dev/null
       ansible-playbook features/files/hosts/localhost.yml -i inventory/linode.py
       """
      And I run "ansible-playbook features/files/hosts/localhost.yml -i inventory/linode.py --check"
     Then I should get:
       """
       PLAY [localhost] ***************************************************************

       TASK [ergonlogic.cloud : Include Linode functionality] *************************
       skipping: [localhost]

       TASK [ergonlogic.cloud : Include AWS functionality] ****************************
       skipping: [localhost]

       PLAY RECAP *********************************************************************
       localhost                  : ok=0    changed=0    unreachable=0    failed=0
       """

  Scenario: Call a command to destroy all defined Linode VMs.
     When I run "make linode-destroy --dry-run"
     Then I should get:
       """
       inventory/linode.py --refresh-cache > /dev/null
       LINODE_STATE=absent ansible-playbook features/files/hosts/localhost.yml -i inventory/linode.py
       """
      And I run "inventory/linode.py --refresh-cache > /dev/null"
      And I run "LINODE_STATE=absent ansible-playbook features/files/hosts/localhost.yml -i inventory/linode.py --check"
     Then I should get:
       """
       PLAY [localhost] ***************************************************************

       TASK [ergonlogic.cloud : Include Linode functionality] *************************
       skipping: [localhost]

       TASK [ergonlogic.cloud : Include AWS functionality] ****************************
       skipping: [localhost]

       PLAY RECAP *********************************************************************
       localhost                  : ok=0    changed=0    unreachable=0    failed=0
       """

