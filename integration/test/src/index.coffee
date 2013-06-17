chai = require 'chai'
chai.should()
expect = chai.expect

ChildDaemon = require 'child-daemon'
supertest = require 'supertest'

describe 'ce-integration', ->
  it.skip 'should start an end to end system', (done) ->
    this.timeout 5000
    request = supertest 'http://localhost:3000'
    childDaemon = new ChildDaemon 'node', [
      'lib/src/index.js'
    ], new RegExp 'Currency Exchange started'
    childDaemon.start (error, matched) =>
      expect(error).to.not.be.ok
      request
      .get('/balances/Peter/EUR')
      .set('Accept', 'application/json')
      .expect(200)
      .expect('Content-Type', /json/)
      .end (error, response) =>
        oldBalance = parseFloat response.body
        request
        .post('/deposits/Peter/')
        .set('Accept', 'application/json')
        .send
          currency: 'EUR'
          amount: '50'
        .expect(200)
        .expect('Content-Type', /json/)
        .end (error, response) =>
          expect(error).to.not.be.ok
          deposit = response.body
          deposit.currency.should.equal 'EUR'
          deposit.amount.should.equal '50'
          deposit.id.should.be.a 'number'
          deposit.status.should.equal 'success'
          setTimeout =>
            request
            .get('/balances/Peter/EUR')
            .set('Accept', 'application/json')
            .expect(200)
            .expect('Content-Type', /json/)
            .end (error, response) =>
              newBalance = parseFloat response.body
              newBalance.should.equal oldBalance + 50
              childDaemon.stop (error) =>
                expect(error).to.not.be.ok
                done()
          , 250
