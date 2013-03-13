require 'spec_helper'

describe "/invoices/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  before(:each) do
    invoice1 && invoice2 && invoice3 && invoice4
  end

  let(:invoice1){ SalesEngineWeb::Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped") }
  let(:invoice2){ SalesEngineWeb::Invoice.create(:customer_id => 2, :merchant_id => 2, :status => "shipped") }
  let(:invoice3){ SalesEngineWeb::Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped") }
  let(:invoice4){ SalesEngineWeb::Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped") }

  describe "find" do
    context "given an existing id" do
      it "finds an invoice" do
        get "/invoices/find?id=#{ invoice1.id }"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq invoice1.id
        expect( output['customer_id'] ).to eq invoice1.customer_id
      end

      it "finds all invoices" do
        get "/invoices/find_all?id=1"
        output = JSON.parse(last_response.body)
        expect( output.count).to eq 1
      end
    end

    context "given an existing customer id" do
      it "finds an invoice" do
        get "/invoices/find?customer_id=#{ invoice1.customer_id }"
        output = JSON.parse(last_response.body)
        expect( output['customer_id'] ).to eq invoice1.customer_id
      end

      it "finds all invoices" do
        get "/invoices/find_all?customer_id=1"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 3
      end
    end

    context "given an existing merchant id" do
      it "finds an invoice" do
        get "/invoices/find?merchant_id=#{ invoice1.merchant_id }"
        output = JSON.parse(last_response.body)
        expect( output['merchant_id'] ).to eq invoice1.merchant_id
      end

      it "finds all invoices" do
        get "/invoices/find_all?merchant_id=1"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 3
      end
    end

    context "given an existing status" do
      it "finds an invoice" do
        get "/invoices/find?status=#{ invoice1.status }"
        output = JSON.parse(last_response.body)
        expect( output['status'] ).to eq invoice1.status
      end

      it "finds all invoices" do
        get "/invoices/find_all?status=shipped"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 4
      end
    end
  end

  describe "random" do
    it "returns a random invoice instance" do
      get "invoices/random"
      output = JSON.parse(last_response.body)
      expect( [ invoice1.id, invoice2.id, invoice3.id, invoice4.id ] ).to include( output['id'] )
    end
  end

  describe "relationships" do
    context "given a specific invoice" do
      it "returns a collection of associated transactions" do
        pending
      end

      it "returns a collection of associated invoice items" do
        pending
      end

      it "returns a collection of associated items" do
        pending
      end

      it "returns a collection of associated customers" do
        pending
      end

      it "returns a collection of associated merchants" do
        pending
      end
    end
  end
end