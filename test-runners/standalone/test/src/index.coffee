chai = require 'chai'
chai.should()
expect = chai.expect

ChildDaemon = require 'child-daemon'
supertest = require 'supertest'

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
      .get('/balances/Peter/EUR')
      .set('Accept', 'application/json')
      .expect(200)
      .expect('Content-Type', /json/)
      .end (error, response) =>
        expect(error).to.not.be.ok
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
          operation = response.body
          operation.account.should.equal 'Peter'
          operation.sequence.should.be.a 'number'
          operation.result.should.equal 'success'
          deposit = operation.deposit
          deposit.currency.should.equal 'EUR'
          deposit.amount.should.equal '50'
          setTimeout =>
            request
            .get('/balances/Peter/EUR')
            .set('Accept', 'application/json')
            .expect(200)
            .expect('Content-Type', /json/)
            .end (error, response) =>
              expect(error).to.not.be.ok
              newBalance = parseFloat response.body
              newBalance.should.equal oldBalance + 50
              childDaemon.stop (error) =>
                expect(error).to.not.be.ok
                done()
          , 250
