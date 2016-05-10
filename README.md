CLOUD
=====

Create and manage virtual machines easily, via a simple manifest. Currently supports Linode. AWS support coming soon.


Requirements
------------

None. [Drumkit](http://github.com/ergonlogic/drumkit) is recommended.

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

Sets whether to set hostnames and build /etc/hosts on Linode VMs.

    linode_manage_hostname_dns_records: True

Sets whether to create and manage default DNS records for hostnames of Linode VMs.

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
