CLOUD
=====

Create and manage virtual machines easily, via a simple manifest. Currently supports Linode. AWS support coming soon.


Requirements
------------

None. [Drumkit](http://github.com/ergonlogic/drumkit) is recommended.

Role Variables
--------------

You'll need to provide a list of virtual machines under the variable `cloud`. Since Ansible cloud modules run on localhost, you might want to keep this variable in `host_vars/localhost.yml` or `hosts/localhost.yml`.

    cloud:
      linode:
        test1:
          #plan: 1024    # Linode 1024        # Optional, defaults to '1024'.
          plan: 1        # Linode 1024       # Optional, defaults to '1'.
          #datacenter: dallas  # Dallas, TX   # Optional, defaults to 'dallas'.
          datacenter: 2  # Dallas, TX        # Optional, defaults to '2'.
          #distro: ubuntu/trusty              # Optional, defaults to 'ubuntu/trusty'.
          distro: 124    # ubuntu/trusty     # Optional, defaults to '124'.
          state: "running"                   # Optional, defaults to 'present'.
        test2: {}                            # Only a name is required.

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

Alternatively, you can keep VM definitions in a separate file, like so:

    # File: hosts/localhost.yml

    - hosts: localhost
      vars_files:
        - ../cloud.yml
      vars:
        ...
      roles:
        - ...
        - ergonlogic.cloud
        - ...

    # File: ./cloud.yml
    cloud:
      linode:
        test1:
          plan: 1          # Linode 1024
          datacenter: 2    # Dallas, TX
          distro: 124      # ubuntu/trusty
          state: "running"
        test2: {}          # Use defaults.
        ...


TODO
----

* Add (and test) sanity check that:
  * Two or more linodes don't share a human-readable name (could cause undefined behaviour)
* Emit warning if linodes exist that are not defined in the manifest
* Add more specific checks when testing linode creation (size, distro, etc.)

License
-------

MIT / BSD

Author Information
------------------

This role was created in 2016 by [Christopher Gervais](http://ergonlogic.com/).
