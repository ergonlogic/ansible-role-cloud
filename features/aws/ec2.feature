@aws @ec2
Feature: Deploy and manage EC2 VMs on AWS
  In order to automate infrastructure deployment
  As a DevOps engineer
  I need to be able to easily work with the AWS EC2 API

  Scenario: Call a command to ensure the proper state of all defined EC2 VMs.
     When I run "make aws-ec2 --dry-run"
     Then I should get:
       """
       inventory/ec2.py --refresh-cache > /dev/null
       ansible-playbook features/files/hosts/localhost.yml -i inventory/ec2.py
       """
      And I run "ansible-playbook features/files/hosts/localhost.yml -i inventory/ec2.py --check"
     Then I should get:
       """
       TASK [ergonlogic.cloud : Include Linode functionality] *************************
       skipping: [localhost]

       TASK [ergonlogic.cloud : Include AWS functionality] ****************************
       skipping: [localhost]

       PLAY RECAP *********************************************************************
       localhost                  : ok=0    changed=0    unreachable=0    failed=0
       """

  Scenario: Call a command to destroy all defined EC2 VMs.
     When I run "make aws-ec2-destroy --dry-run"
     Then I should get:
       """
       inventory/ec2.py --refresh-cache > /dev/null
       AWS_EC2_STATE=absent ansible-playbook features/files/hosts/localhost.yml -i inventory/ec2.py
       """
      And I run "inventory/ec2.py --refresh-cache > /dev/null"
      And I run "AWS_EC2_STATE=absent ansible-playbook features/files/hosts/localhost.yml -i inventory/ec2.py --check"
     Then I should get:
       """
       TASK [ergonlogic.cloud : Include Linode functionality] *************************
       skipping: [localhost]

       TASK [ergonlogic.cloud : Include AWS functionality] ****************************
       skipping: [localhost]

       PLAY RECAP *********************************************************************
       localhost                  : ok=0    changed=0    unreachable=0    failed=0
       """

