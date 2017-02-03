CLOUD
=====


[![Build Status](https://travis-ci.org/ergonlogic/ansible-role-cloud.svg?branch=master)](https://travis-ci.org/ergonlogic/ansible-role-cloud)

Create and manage virtual machines easily, via a simple manifest. Currently supports Linode. AWS support coming soon.

Background
----------

Ansible core includes powerful modules and inventory scripts that make working with cloud providers relatively easy. However, a number of these modules don't handle idempotency gracefully. That is, if one defines (for example) an EC2 instance task, and run Ansible, it will create a VM. If Ansible is run again, without entering the newly created VMs identifier, a second VM will be created.

This module seeks to improve on that stuation by building a dynamic inventory, and mapping human-readable names to machine-readable resource IDs. By wrapping around Ansible's native cloud modules, we can work with a consistent, idempotent, cross-provider framework for managing cloud infrastructure. Better yet, it simplifies such usage by setting reasonable (configurable) defaults, and allowing the use of human-readable names across resources.

Requirements
------------

[Drumkit](http://drumk.it) is recommended, and included as a git submodule. If you did not use the `--recursive` option when cloning this repository, you can install Drumkit by running the following:

    git submodule update --init

Cloud providers require various forms of security tokens to ensure only authorized users can access their APIs. To use this role's cloud provisioning functionality, you can create the following files to contain your tokens:

* `linode.api.key`
* `aws.access.key`
* `aws.access.secret`

These files are ignored by Git, so as not to be committed into your infrastructure repo by mistake.

When you bootstrap Drumkit (by running `. d`) the values contained in those files will be assigned to the necessary environmental variables (i.e., `LINODE_API_KEY`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) to allow Ansible to connect to your cloud provider accounts.


Role Variables
--------------

    cloud:
      linode:
        test1:
          plan: 1        # Linode 1024       # Optional, defaults to '1'.
          datacenter: 2  # Dallas, TX        # Optional, defaults to '2'.
          distro: 124    # ubuntu/trusty     # Optional, defaults to '124'.
          state: "running"                   # Optional, defaults to 'present'.
        test2: {}                            # Only a name is required.

A list of virtual machines and their attributes. Since Ansible cloud modules run on localhost, you might want to keep this variable in `host_vars/localhost.yml` or `hosts/localhost.yml`.

    linode_set_hostnames: True

Sets whether to set hostnames and build /etc/hosts on Linode VMs. Defaults to 'True'.

    linode_manage_hostname_dns_records: True

Sets whether to create and manage default DNS records for hostnames of Linode VMs. Defaults to 'True'.

    linode_zone: example.com

The DNS zone to create in the Linode DNS Manager, and to use in building Linode VM FQDNs.

    linode_zone_soa_email: user@example.com

SOA Email record for the specified zone.

    linode_state: 'present'

The default state to set for Linode VMs.

    op: 'linode'

The type of operation to perform.

Dependencies
------------

None.

Example Playbook
----------------

Include in localhost as you would any other cloud role.

    - hosts: localhost
      vars:
        ...
        cloud:
          linode:
            test1:
              plan: 1          # Linode 1024
              datacenter: 2    # Dallas, TX
              distro: 124      # ubuntu/trusty
              state: "running"
            test2: {}          # Use defaults.
        ...
      roles:
        - ...
        - ergonlogic.cloud
        - ...


TODO
----

* Add (and test) sanity check that:
  * Two or more linodes don't share a human-readable name (could cause undefined behaviour)
* Emit warning if Linode VMs exist that are not defined in the manifest
* Add more specific checks when testing linode creation (size, distro, etc.)
* Test hostname and domain functionality
* Add reverse DNS setup.

License
-------

GPLv3 or later

Author Information
------------------

This role was created in 2016 by [Christopher Gervais](http://ergonlogic.com/).
