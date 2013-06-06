currency-exchange
=================

End to end currency exchange implementation

The following components make up the end to end system

- ce-load-balancer - haproxy instance load balancing the ce-front-end instance
- ce-front-end-1|2|3 - 3 load balanced instances of the front end interface that does initial authentication and validation of operations and queries over a REST interface
- ce-operation-hub - single nexus for receiving operations from the ce-front-end instances, assigning sequence IDs, logging and broadcasting them to the engine instances and reporting back success or failure
- ce-engine-1|2|3 - 3 redundant currency market order matching engines

## Contributing

Note that this project is an end to end development environment for the various currency exchange components. As such those components are included here as git submodules. After cloning you will need to initialise the submodules

```
git submodule init
git submodule update
```

You should then use vagrant (see below) to instantiate VMs for each component and work in them.

NB. Remember to commit the submodules you are working in first before commiting the changes to the currency-exchange project.

For specifics with regard to working in each submodule see their respective README.md

### Using Vagrant
To use the Vagrantfile you will also need to install the following vagrant plugins

```
$ vagrant plugin install vagrant-omnibus
$ vagrant plugin install vagrant-berkshelf
$ vagrant plugin install vagrant-hostmanager
```

### Workaround for firewalls that block default git:// port
As `engine.io-client` has a dependency on a `git://github.com/` url based module `npm install` will fail if the default port for `git://` urls is blocked by a firewall. These urls can be rewritten to `https://github.com/` with this git configuration change

```
$ git config --global url.https://github.com/.insteadOf git://github.com/
```

## License
Copyright (c) 2013 Peter Halliday  
Licensed under the MIT license.
