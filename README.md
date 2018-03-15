salt-formulas
=============

A collection of [Salt formulas](https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html), tested on Ubuntu 16.04 only. Each formula downloads (into [/opt/src](https://github.com/joncody/salt-formulas/blob/master/optsrc/init.sls)), configures, builds, and installs to `/opt`. Naturally, installing to a custom location requires updating some environment variables - [bashrc]() takes care of this for us.
