(function() {
  var chai, expect, supertest;

  chai = require('chai');

  chai.should();

  expect = chai.expect;

  supertest = require('supertest');

  describe('Currency Exchange', function() {
    return describe('REST API', function() {
      var request;
      console.log(process.env.npm_package_config_host);
      console.log(process.env.npm_package_config_port);
      request = supertest('http://' + process.env.npm_package_config_host + ':' + process.env.npm_package_config_port);
      describe('/', function() {
        return it('should return the home page', function(done) {
          return request.get('/').expect(200).expect('hello', done);
        });
      });
      describe('/balances/[account]/', function() {
        return it('should respond to GET requests', function(done) {
          var _this = this;
          return request.get('/balances/Peter/').set('Accept', 'application/json').expect(200).expect('Content-Type', /json/).end(function(error, response) {
            var balances;
            expect(error).to.not.be.ok;
            balances = response.body;
            balances.should.be.an('object');
            return done();
          });
        });
      });
      describe('/balances/[account]/[currency]', function() {
        return it('should respond to GET requests', function(done) {
          var _this = this;
          return request.get('/balances/Peter/EUR').set('Accept', 'application/json').expect(200).expect('Content-Type', /json/).end(function(error, response) {
            var balance;
            expect(error).to.not.be.ok;
            balance = response.body;
            balance.should.equal('0');
            return done();
          });
        });
      });
      describe('/deposits/[account]/', function() {
        return it.skip('should accept posted deposits which should be visible through a balance query within 250 milliseconds', function(done) {
          var _this = this;
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
                  return done();
                });
              }, 250);
            });
          });
        });
      });
      return describe('/orders/[account]/', function() {
        return it('should accept posted orders', function(done) {
          var _this = this;
          return request.post('/orders/Peter/').set('Accept', 'application/json').send({
            bidCurrency: 'EUR',
            offerCurrency: 'BTC',
            bidPrice: '100',
            bidAmount: '50'
          }).expect(200).expect('Content-Type', /json/).end(function(error, response) {
            var order;
            expect(error).to.not.be.ok;
            order = response.body;
            order.bidCurrency.should.equal('EUR');
            order.offerCurrency.should.equal('BTC');
            order.bidPrice.should.equal('100');
            order.bidAmount.should.equal('50');
            order.id.should.be.a('number');
            order.status.should.equal('success');
            return done();
          });
        });
      });
    });
  });

}).call(this);
