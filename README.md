salt-formulas
=============

A collection of [Salt formulas](https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html), tested on Ubuntu only. Each formula downloads (into [/opt/src](https://github.com/joncody/salt-formulas/blob/master/optsrc/init.sls)), configures, builds, and installs to `/opt`. Naturally, installing to a custom location requires updating some environment variables - [bashrc](https://github.com/joncody/salt-formulas/blob/master/bashrc/init.sls) takes care of this for us.
More specifically, [custom.bashrc](https://github.com/joncody/salt-formulas/blob/master/bashrc/files/custom.bashrc) is appended to `/etc/bash.bashrc` and tells the machine to update `PATH`, `LIBRARY_PATH`, `LD_LIBRARY_PATH`, `CPATH`, and `PKG_CONFIG_PATH` by searching `/opt`.
[custom.sudoers](https://github.com/joncody/salt-formulas/blob/master/bashrc/files/custom.sudoers) is a one liner appended to `/etc/sudoers` enabling all users in group `sudo` to execute the `find` command without having to type in a password.
