chai = require 'chai'
chai.should()
expect = chai.expect
supertest = require 'supertest'

describe 'Currency Exchange', ->
  describe 'REST API', ->
    request = supertest 'http://' + process.env.npm_package_config_host + ':' + process.env.npm_package_config_port

    describe '/', ->
      it 'should return the home page', (done) ->
        request
        .get('/')
        .expect(200)
        .expect 'hello', done

    describe '/hal/browser.html', ->
      it 'should serve the HAL browser', (done) ->
        request
        .get('/hal/browser.html')
        .set('Accept', 'text/html')
        .expect(200)
        .expect('Content-Type', /html/)
        .expect /The HAL Browser/, done

    describe '/balances/[account]/', ->
      it 'should respond to GET requests', (done) ->
        request
        .get('/balances/Peter/')
        .set('Accept', 'application/json')
        .expect(200)
        .expect('Content-Type', /json/)
        .end (error, response) =>
          expect(error).to.not.be.ok
          balances = response.body
          balances.should.be.an 'object'
          done()

    describe '/balances/[account]/[currency]', ->
      it 'should respond to GET requests', (done) ->
        request
        .get('/balances/Peter/EUR')
        .set('Accept', 'application/json')
        .expect(200)
        .expect('Content-Type', /json/)
        .end (error, response) =>
          expect(error).to.not.be.ok
          balance = response.body
          balance.should.be.an 'object'
          done()

    describe '/deposits/[account]/', ->
      it 'should accept posted deposits which should be visible through a balance query within 250 milliseconds', (done) ->
        startTime = Date.now()
        # get current balances
        request
        .get('/balances/Peter/EUR')
        .set('Accept', 'application/json')
        .expect(200)
        .expect('Content-Type', /json/)
        .end (error, response) =>
          oldBalance = parseFloat response.body.funds
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
            .post('/deposits/Peter/')
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
                .get('/balances/Peter/EUR')
                .set('Accept', 'application/json')
                .expect(200)
                .expect('Content-Type', /json/)
                .end (error, response) =>
                  newBalance = parseFloat response.body.funds
                  newBalance.should.equal oldBalance + 200
                  done()
              , 250

    describe '/orders/[account]/', ->
      it 'should accept posted orders', (done) ->
        startTime = Date.now()
        request
        .post('/deposits/Peter/')
        .set('Accept', 'application/json')
        .send
          currency: 'EUR'
          amount: '5000'
        .expect(200)
        .expect('Content-Type', /json/)
        .end (error, response) =>
          expect(error).to.not.be.ok
          request
          .post('/orders/Peter/')
          .set('Accept', 'application/json')
          .send
            bidCurrency: 'BTC'
            offerCurrency: 'EUR'
            bidPrice: '100'
            bidAmount: '50'
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
            submit = operation.submit
            submit.bidCurrency.should.equal 'BTC'
            submit.offerCurrency.should.equal 'EUR'
            submit.bidPrice.should.equal '100'
            submit.bidAmount.should.equal '50'
            delta = response.body.delta
            delta.result.lockedFunds.should.be.a 'string'
            error = response.body.error
            expect(error).to.not.be.ok
            done()

      it 'should report errors from the engine', (done) ->
        startTime = Date.now()
        request
        .post('/orders/Peter/')
        .set('Accept', 'application/json')
        .send
          bidCurrency: 'BTC'
          offerCurrency: 'XXX'
          bidPrice: '100'
          bidAmount: '50'
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
          submit = operation.submit
          submit.bidCurrency.should.equal 'BTC'
          submit.offerCurrency.should.equal 'XXX'
          submit.bidPrice.should.equal '100'
          submit.bidAmount.should.equal '50'
          delta = response.body.delta
          expect(delta).to.not.be.ok
          error = response.body.error
          error.should.equal 'Error: Cannot lock funds that are not available'
          done()

