Feature: Infrastructure testing tools
  In order to test infrastructure automation
  As a DevOps engineer
  I need to be able to ensure the proper tools are installed

  Scenario: Check that Ansible is installed (via Drumkit)
     When I run "make ansible"
     When I run "which ansible"
     Then I should get:
       """
       .mk/.local/bin/ansible
       """

  Scenario: Check that Behat is installed (via Drumkit)
     When I run "make behat"
     When I run "which behat"
     Then I should get:
       """
       .mk/.local/bin/behat
       """
