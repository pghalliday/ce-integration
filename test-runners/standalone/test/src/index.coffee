chai = require 'chai'
chai.should()
expect = chai.expect

ChildDaemon = require 'child-daemon'
supertest = require 'supertest'

Operation = require('currency-market').Operation
Delta = require('currency-market').Delta
Amount = require('currency-market').Amount

describe 'currency-exchange', ->
  it 'should start an end to end system', (done) ->
    this.timeout 5000
    request = supertest 'http://localhost:7000'
    childDaemon = new ChildDaemon 'node', [
      'lib/local/src/index.js'
      '--config'
      'test/support/config.json'
    ], new RegExp 'Currency Exchange started'
    childDaemon.start (error, matched) =>
      expect(error).to.not.be.ok
      request
      .get('/accounts/Peter/balances/EUR')
      .set('Accept', 'application/hal+json')
      .expect(200)
      .expect('Content-Type', /hal\+json/)
      .end (error, response) =>
        expect(error).to.not.be.ok
        halResponse = JSON.parse response.text
        oldBalance = parseFloat halResponse.funds
        request
        .post('/accounts/Peter/deposits')
        .set('Accept', 'application/hal+json')
        .send
          currency: 'EUR'
          amount: '50'
        .expect(200)
        .expect('Content-Type', /hal\+json/)
        .end (error, response) =>
          expect(error).to.not.be.ok
          halResponse = JSON.parse response.text
          setTimeout =>
            request
            .get('/accounts/Peter/balances/EUR')
            .set('Accept', 'application/hal+json')
            .expect(200)
            .expect('Content-Type', /hal\+json/)
            .end (error, response) =>
              expect(error).to.not.be.ok
              halResponse = JSON.parse response.text
              newBalance = parseFloat halResponse.funds
              newBalance.should.equal oldBalance + 50
              childDaemon.stop (error) =>
                expect(error).to.not.be.ok
                done()
          , 250
