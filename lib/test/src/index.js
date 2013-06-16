(function() {
  var ChildDaemon, chai, expect, supertest;

  chai = require('chai');

  chai.should();

  expect = chai.expect;

  ChildDaemon = require('child-daemon');

  supertest = require('supertest');

  describe('ce-integration', function() {
    return it.skip('should start an end to end system', function(done) {
      var childDaemon, request,
        _this = this;
      this.timeout(5000);
      request = supertest('http://localhost:3000');
      childDaemon = new ChildDaemon('node', ['lib/src/index.js'], new RegExp('Currency Exchange started'));
      return childDaemon.start(function(error, matched) {
        expect(error).to.not.be.ok;
        return request.get('/balances/Peter/EUR').set('Accept', 'application/json').expect(200).expect('Content-Type', /json/).end(function(error, response) {
          var oldBalance;
          oldBalance = parseFloat(response.body);
          return request.post('/deposits/Peter/').set('Accept', 'application/json').send({
            currency: 'EUR',
            amount: '50'
          }).expect(200).expect('Content-Type', /json/).end(function(error, response) {
            var deposit;
            expect(error).to.not.be.ok;
            deposit = response.body;
            deposit.currency.should.equal('EUR');
            deposit.amount.should.equal('50');
            deposit.id.should.be.a('number');
            deposit.status.should.equal('success');
            return setTimeout(function() {
              return request.get('/balances/Peter/EUR').set('Accept', 'application/json').expect(200).expect('Content-Type', /json/).end(function(error, response) {
                var newBalance;
                newBalance = parseFloat(response.body);
                newBalance.should.equal(oldBalance + 50);
                return childDaemon.stop(function(error) {
                  expect(error).to.not.be.ok;
                  return done();
                });
              });
            }, 250);
          });
        });
      });
    });
  });

}).call(this);
