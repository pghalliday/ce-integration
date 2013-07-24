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
          .set('Accept', 'application/hal+json')
          .send
            currency: 'EUR'
            amount: '50'
          .expect(200)
          .expect('Content-Type', /hal\+json/)
          .end (error, response) =>
            expect(error).to.not.be.ok
            request
            .post('/accounts/Peter/deposits')
            .set('Accept', 'application/hal+json')
            .send
              currency: 'EUR'
              amount: '150'
            .expect(200)
            .expect('Content-Type', /hal\+json/)
            .end (error, response) =>
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
