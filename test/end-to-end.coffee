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
          balance.should.be.a 'string'
          done()

    describe '/deposits/[account]/', ->
      it 'should accept posted deposits which should be visible through a balance query within 250 milliseconds', (done) ->
        # get current balances
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
            operation = response.body
            operation.account.should.equal 'Peter'
            operation.id.should.be.a 'number'
            operation.result.should.equal 'success'
            deposit = operation.deposit
            deposit.currency.should.equal 'EUR'
            deposit.amount.should.equal '50'
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
              operation = response.body
              operation.account.should.equal 'Peter'
              operation.id.should.be.a 'number'
              operation.result.should.equal 'success'
              deposit = operation.deposit
              deposit.currency.should.equal 'EUR'
              deposit.amount.should.equal '150'
              setTimeout =>
                request
                .get('/balances/Peter/EUR')
                .set('Accept', 'application/json')
                .expect(200)
                .expect('Content-Type', /json/)
                .end (error, response) =>
                  newBalance = parseFloat response.body
                  newBalance.should.equal oldBalance + 200
                  done()
              , 250

    describe '/orders/[account]/', ->
      it 'should accept posted orders', (done) ->
        request
        .post('/orders/Peter/')
        .set('Accept', 'application/json')
        .send
          bidCurrency: 'EUR'
          offerCurrency: 'BTC'
          bidPrice: '100'
          bidAmount: '50'
        .expect(200)
        .expect('Content-Type', /json/)
        .end (error, response) =>
          expect(error).to.not.be.ok
          operation = response.body
          operation.account.should.equal 'Peter'
          operation.id.should.be.a 'number'
          operation.result.should.equal 'success'
          order = operation.order
          order.bidCurrency.should.equal 'EUR'
          order.offerCurrency.should.equal 'BTC'
          order.bidPrice.should.equal '100'
          order.bidAmount.should.equal '50'
          done()


