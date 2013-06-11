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

    describe '/accounts/[account]/orders/', ->
      it 'should accept posted orders', (done) ->
        request
        .post('/accounts/Peter/orders/')
        .set('Accept', 'application/json')
        .send
          bidCurrency: 'EUR'
          offerCurrency: 'BTC'
          bidPrice: '100'
          bidAmount: '50'
        .expect(200)
        .expect('Content-Type', /json/)
        .end (error, response) =>
          order = response.body
          order.bidCurrency.should.equal 'EUR'
          order.offerCurrency.should.equal 'BTC'
          order.bidPrice.should.equal '100'
          order.bidAmount.should.equal '50'
          order.id.should.be.a 'number'
          order.status.should.equal 'success'
          done()

