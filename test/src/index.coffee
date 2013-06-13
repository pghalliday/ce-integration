chai = require 'chai'
chai.should()
expect = chai.expect
supertest = require 'supertest'

describe 'Currency Exchange', ->
  describe 'REST API', ->
    request = supertest 'http://haproxy'

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

    describe '/deposits/[account]/', ->
      it 'should accept posted deposits', (done) ->
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
          done()

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
          order = response.body
          order.bidCurrency.should.equal 'EUR'
          order.offerCurrency.should.equal 'BTC'
          order.bidPrice.should.equal '100'
          order.bidAmount.should.equal '50'
          order.id.should.be.a 'number'
          order.status.should.equal 'success'
          done()

