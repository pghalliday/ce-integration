cookbook-test
=============

Chef cookbook to set up a currency exchange test runner environment

## Depends

- nodejs

## Attributes

- `node[:test][:installDirectory]` - the directory in which the tests exist (defaults to "/vagrant/test")

## Recipes

### default

Installs Node.js, switches to the test directory, runs npm install and npm test

## License
Copyright (c) 2013 Peter Halliday  
Licensed under the MIT license.
