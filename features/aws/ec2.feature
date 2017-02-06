@aws @ec2
Feature: Deploy and manage EC2 VMs on AWS
  In order to automate infrastructure deployment
  As a DevOps engineer
  I need to be able to easily work with the AWS EC2 API

  Scenario: Call a command to ensure the proper state of all defined EC2 VMs.
     When I run "make aws-ec2-force --dry-run"
     Then I should get:
       """
       inventory/ec2.py --refresh-cache > /dev/null
       ansible-playbook features/files/hosts/localhost.yml -i inventory/ec2.py -e "confirm=y"
       """
      And I run "ansible-playbook features/files/hosts/localhost.yml -i inventory/ec2.py -e'confirm=y' --check"
     Then I should get:
       """
       TASK [ergonlogic.cloud : Include 'inventory' tasks.] ***
       skipping: [localhost]

       TASK [ergonlogic.cloud : Check environment for AWS_EC2_STATE.] ***
       ok: [localhost]

       TASK [ergonlogic.cloud : Include tasks to create missing EC2 VMs.] ***
       skipping: [localhost]

       TASK [ergonlogic.cloud : Include tasks to ensure the proper state and group of EC2 VMs.] ***
       skipping: [localhost]
       """

  Scenario: Call a command to destroy all defined EC2 VMs.
     When I run "make aws-ec2-destroy-force --dry-run"
     Then I should get:
       """
       inventory/ec2.py --refresh-cache > /dev/null
       AWS_EC2_STATE=absent ansible-playbook features/files/hosts/localhost.yml -i inventory/ec2.py -e "confirm=y"
       """
      And I run "inventory/ec2.py --refresh-cache > /dev/null"
      And I run "AWS_EC2_STATE=absent ansible-playbook features/files/hosts/localhost.yml -i inventory/ec2.py -e'confirm=y' --check"
     Then I should get:
       """
       TASK [ergonlogic.cloud : Include 'inventory' tasks.] ***
       skipping: [localhost]

       TASK [ergonlogic.cloud : Check environment for AWS_EC2_STATE.] ***
       ok: [localhost]

       TASK [ergonlogic.cloud : Include tasks to create missing EC2 VMs.] ***
       skipping: [localhost]

       TASK [ergonlogic.cloud : Include tasks to ensure the proper state and group of EC2 VMs.] ***
       skipping: [localhost]
       """

