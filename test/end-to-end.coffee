chai = require 'chai'
chai.should()
expect = chai.expect
supertest = require 'supertest'

describe 'Currency Exchange', ->
  describe 'REST API', ->
    request = supertest 'http://' + process.env.npm_package_config_host + ':' + process.env.npm_package_config_port

    describe '/accounts/:id/deposits', ->
      it 'should accept posted deposits which should be visible through a balance query within 250 milliseconds', (done) ->
        startTime = Date.now()
        # get current balances
        request
        .get('/accounts/Peter/balances/EUR')
        .set('Accept', 'application/hal+json')
        .expect(200)
        .expect('Content-Type', /hal\+json/)
        .end (error, response) =>
          halResponse = JSON.parse response.text
          oldBalance = parseFloat halResponse.funds
          request
          .post('/accounts/Peter/deposits')
          .set('Accept', 'application/json')
          .send
            currency: 'EUR'
            amount: '50'
          .expect(200)
          .expect('Content-Type', /json/)
          .end (error, response) =>
            expect(error).to.not.be.ok
            operation = response.body.operation
            operation.reference.should.be.a 'string'
            operation.account.should.equal 'Peter'
            operation.sequence.should.be.a 'number'
            operation.timestamp.should.be.at.least startTime
            operation.timestamp.should.be.at.most Date.now()
            deposit = operation.deposit
            deposit.currency.should.equal 'EUR'
            deposit.amount.should.equal '50'
            delta = response.body.delta
            delta.result.funds.should.be.a 'string'
            request
            .post('/accounts/Peter/deposits')
            .set('Accept', 'application/json')
            .send
              currency: 'EUR'
              amount: '150'
            .expect(200)
            .expect('Content-Type', /json/)
            .end (error, response) =>
              expect(error).to.not.be.ok
              operation = response.body.operation
              operation.account.should.equal 'Peter'
              operation.sequence.should.be.a 'number'
              deposit = operation.deposit
              deposit.currency.should.equal 'EUR'
              deposit.amount.should.equal '150'
              delta = response.body.delta
              delta.result.funds.should.be.a 'string'
              error = response.body.error
              expect(error).to.not.be.ok
              setTimeout =>
                request
                .get('/accounts/Peter/balances/EUR')
                .set('Accept', 'application/hal+json')
                .expect(200)
                .expect('Content-Type', /hal\+json/)
                .end (error, response) =>
                  halResponse = JSON.parse response.text
                  newBalance = parseFloat halResponse.funds
                  newBalance.should.equal oldBalance + 200
                  done()
              , 250
