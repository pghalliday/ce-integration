CeOperationHub = require '/ce-operation-hub'
CeDeltaHub = require '/ce-delta-hub'
CeEngine = require '/ce-engine'
CeFrontEnd = require '/ce-front-end'
nconf = require 'nconf'
step = require 'step'

# load configuration
nconf.argv()
config = nconf.get 'config'
if config
  nconf.file
    file: config

console.log JSON.stringify nconf.get(), null, 4

step ->
  group = this.group()
  ceOperationHub = new CeOperationHub nconf.get 'ce-operation-hub'
  ceOperationHub.start group()
  ceDeltaHub = new CeDeltaHub nconf.get 'ce-delta-hub'
  ceDeltaHub.start group()
  nconf.get('ce-engine').forEach (config) ->
    ceEngine = new CeEngine config
    ceEngine.start group()
  nconf.get('ce-front-end').forEach (config) ->
    ceFrontEnd  = new CeFrontEnd config
    ceFrontEnd.start group()
, (error, started) ->
  if error
    console.trace error
    started.forEach (server) ->
      server.stop()
  else
    console.log 'Currency Exchange started'
