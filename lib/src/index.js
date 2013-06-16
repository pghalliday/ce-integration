(function() {
  var CeDeltaHub, CeEngine, CeFrontEnd, CeOperationHub, config, cwd, nconf, step;

  cwd = process.cwd();

  CeOperationHub = require(cwd + '/ce-operation-hub/lib/src/Server.js');

  CeDeltaHub = require(cwd + '/ce-delta-hub/lib/src/Server.js');

  CeEngine = require(cwd + '/ce-engine/lib/src/Server.js');

  CeFrontEnd = require(cwd + '/ce-front-end/lib/src/Server.js');

  nconf = require('nconf');

  step = require('step');

  nconf.argv();

  config = nconf.get('config');

  if (config) {
    nconf.file({
      file: config
    });
  }

  console.log(nconf.get());

  step(function() {
    var ceDeltaHub, ceOperationHub, group;
    group = this.group();
    ceOperationHub = new CeOperationHub(nconf.get('ce-operation-hub'));
    ceOperationHub.start(group());
    ceDeltaHub = new CeDeltaHub(nconf.get('ce-delta-hub'));
    ceDeltaHub.start(group());
    nconf.get('ce-engine').forEach(function(config) {
      var ceEngine;
      ceEngine = new CeEngine(config);
      return ceEngine.start(group());
    });
    return nconf.get('ce-front-end').forEach(function(config) {
      var ceFrontEnd;
      ceFrontEnd = new CeFrontEnd(config);
      return ceFrontEnd.start(group());
    });
  }, function(error, started) {
    if (error) {
      console.log(error);
      return started.forEach(function(server) {
        return server.stop();
      });
    } else {
      return console.log('Currency Exchange started');
    }
  });

}).call(this);
