currency-exchange
=================

End to end currency exchange integration

The following VMs will be created by `Vagrant`

Cookbook | Notes | Instances
---|---|:---:
`test` | This is the machine on which the tests will be run | `test`
`haproxy` | This is the load balancer | `haproxy`
`ce-front-end` | Load balanced ce-front-end instances pre-validate operations before passing them to the ce-operation-hub | `ce-front-end-1` `ce-front-end-2` `ce-front-end-3`
`ce-operation-hub` | Single ce-operation-hub instance ensures that the sequence of operations is logged and broadcasts them to the ce-engine instances | `ce-operation-hub`
`ce-engine` | Redundant ce-engine instances receive and process the operations | `ce-engine-1` `ce-engine-2` `ce-engine-3`

## Contributing

Note that this project is an end to end development environment for the various currency exchange components. As such those components are included here as git submodules. Clone using the `--recursive` option.

```
$ git clone --recursive https://github.com/pghalliday/currency-exchange.git
```

If you don't then after cloning you will need to initialise the submodules and the submodules of the submodules.

```
$ git submodule update --init --recursive
```

You should then use vagrant (see below) to instantiate VMs for each component and work in them.

NB. Remember to commit the submodules you are working in first before commiting the changes to the currency-exchange project.

For specifics with regard to working in each submodule see their respective README.md

### Prerequisites

- VirtualBox - https://www.virtualbox.org/wiki/Downloads
- Vagrant - http://downloads.vagrantup.com/

Additionally the following vagrant plugins should be installed

```
$ vagrant plugin install vagrant-omnibus
$ vagrant plugin install vagrant-berkshelf
$ vagrant plugin install vagrant-hostmanager
```

### Running the tests

- Start all the VMs (this will definitely take a **very** long time the first time it is run)

```
$ cd currency-exchange
$ vagrant up
```

- connect to the `ce-test` instance

```
$ vagrant ssh ce-test
```

- Run the tests

```
vagrant@ce-test:~$ cd /vagrant
vagrant@ce-test:~$ npm test
```

## License
Copyright (c) 2013 Peter Halliday  
Licensed under the MIT license.
