require 'spec_helper'

describe "/transactions/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  before(:each) do
    transaction1 && transaction2 && transaction3 && transaction4
  end

  let(:transaction1){ SalesEngineWeb::Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success") }
  let(:transaction2){ SalesEngineWeb::Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success") }
  let(:transaction3){ SalesEngineWeb::Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "failed") }
  let(:transaction4){ SalesEngineWeb::Transaction.create(:invoice_id => 3, :credit_card_number => 5555555555555555, :credit_card_expiration_date => "", :result => "failed") }

  describe "find" do
    context "given an existing id" do
      it "finds the transaction" do
        get "/transactions/find?id=#{ transaction1.id }"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq transaction1.id
        expect( output['invoice_id'] ).to eq transaction1.invoice_id
      end

      it "finds all transactions associated with the id" do
        get "/transactions/find_all?id=1"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 1
      end
    end

    context "given an existing invoice id" do
      it "finds a transaction" do
        get "/transactions/find?invoice_id=#{ transaction1.invoice_id }"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq transaction1.id
        expect( output['invoice_id'] ).to eq transaction1.invoice_id
      end

      it "finds all transactions" do
        get "/transactions/find_all?invoice_id=1"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 2
      end
    end

    context "given an existing credit card number" do
      it "finds a transaction" do
        get "/transactions/find?credit_card_number=#{ transaction1.credit_card_number }"
        output = JSON.parse(last_response.body)
        expect( output['credit_card_number'] ).to eq transaction1.credit_card_number
        expect( output['invoice_id'] ).to eq transaction1.invoice_id
      end

      it "finds all transactions" do
        get "/transactions/find_all?credit_card_number=4444444444444444"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 3
      end
    end

    context "given an existing result" do
      it "finds a transaction" do
        get "/transactions/find?result=#{ transaction1.result }"
        output = JSON.parse(last_response.body)
        expect( output['result'] ).to eq transaction1.result
        expect( output['invoice_id'] ).to eq transaction1.invoice_id
      end

      it "finds all transactions" do
        get "/transactions/find_all?result=failed"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 2
      end
    end
  end

  describe "random" do
    it "returns a random transaction instance" do
      get "/transactions/random"
      output = JSON.parse(last_response.body)
      expect( [ transaction1.id, transaction2.id, transaction3.id, transaction4.id ] ).to include( output['id'] )
    end
  end

  describe "relationships" do
    context "given a specific transaction" do
      it "returns the associated invoice" do
        pending
      end
    end
  end
end