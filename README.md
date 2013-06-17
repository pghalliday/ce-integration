ce-integration
==============

End to end currency exchange integration

The following VMs will be created by `Vagrant`

Cookbook | Notes | Instances
---|---|:---:
`test-runner` | This is the machine on which the tests will be run | `test-runner`
`haproxy` | This is the load balancer | `haproxy`
`ce-front-end` | Load balanced ce-front-end instances pre-validate operations before passing them to the ce-operation-hub | `ce-front-end-1` `ce-front-end-2` `ce-front-end-3`
`ce-operation-hub` | Single ce-operation-hub instance ensures that the sequence of operations is logged and broadcasts them to the ce-engine instances | `ce-operation-hub`
`ce-delta-hub` | Single ce-delta-hub instance synchronises market state between ce-engine instances and ce-front-end instances | `ce-delta-hub`
`ce-engine` | Redundant ce-engine instances receive and process the operations | `ce-engine-1` `ce-engine-2` `ce-engine-3`

## Contributing

Note that this project is an end to end development environment for the various currency exchange components. As such those components are included here as git submodules. Clone using the `--recursive` option.

```
$ git clone --recursive https://github.com/pghalliday/ce-integration.git
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

### Using the `test-runners`

#### The `distributed` test runner

This should be the default method of running end to end tests as it is the most like the target deployment environment. This runner creates a VM for each server instance and as such requires quite a lot of memory

- Start all the VMs (this will definitely take a **very** long time the first time it is run)

```
$ cd ce-integration
$ cd test-runners/distributed
$ vagrant up
```

- connect to the `test-runner` instance

```
$ vagrant ssh test-runner
```

- Run the tests

```
vagrant@test-runner:~$ cd /vagrant
vagrant@test-runner:/vagrant$ npm test
```

- The tests are always run when the VMs are reloaded. As such re-running the end to end tests after changes can be achieved through

```
$ vagrant reload
```

- To work in the components

```
$ vagrant ssh [component-name]
vagrant@[component-name]:~$ cd /[component-name]
vagrant@[component-name]:/[component-name]$ npm test
```

- Note that after making changes it will be necessary to restart the component instances before running end to end tests

```
vagrant@[component-name]:/[component-name]$ npm restart
```

- When working in the `ce-front-end` or `ce-engine` source it is necessary to restart all the instances before running end to end tests. As the tests are always run when the VMs are reloaded this can be achieved by restarting all the VMs

```
$ vagrant reload
```


#### The `standalone` test runner

This is a less memory intensive test runner as it uses only 1 VM. It is also used by Travis which currently does not support multiple VMs

- Start the VM

```
$ cd ce-integration
$ cd test-runners/standalone
$ vagrant up
```

- connect to the `test-runner` instance

```
$ vagrant ssh
```

- Run the tests

```
vagrant@test-runner:~$ cd /vagrant
vagrant@test-runner:/vagrant$ npm test
```

- To work in the components

```
vagrant@test-runner:~$ cd /[component-name]
vagrant@test-runner:/[component-name]$ npm test
```

- After changes it will be necessary to restart the server instances before re-running the tests

```
vagrant@test-runner:~$ cd /vagrant
vagrant@test-runner:/vagrant$ npm restart
vagrant@test-runner:/vagrant$ npm test
```

## License
Copyright (c) 2013 Peter Halliday  
Licensed under the MIT license.
