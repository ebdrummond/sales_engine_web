require 'spec_helper'

describe "/merchants/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  before(:each) do
    merchant1 && merchant2 && merchant3 && merchant4
  end

  let(:merchant1){ SalesEngineWeb::Merchant.create(:name => "Jumpstart Lab") }
  let(:merchant2){ SalesEngineWeb::Merchant.create(:name => "gSchool") }
  let(:merchant3){ SalesEngineWeb::Merchant.create(:name => "Galvanize") }
  let(:merchant4){ SalesEngineWeb::Merchant.create(:name => "Galvanize") }

  describe "random" do
    it "returns a random merchant" do
      get '/merchants/random'
      output = JSON.parse(last_response.body)
      expect( [ merchant1.id, merchant2.id, merchant3.id, merchant4.id ] ).to include( output['id'] )
    end
  end

  describe "find" do
    context "given an existing id" do
      it "finds the merchant" do
        get "/merchants/find?id=#{ merchant1.id }"
        pending
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq merchant1.id
        expect( output['name'] ).to eq merchant1.name
      end

      it "finds merchant2" do
        get "/merchants/find?id=#{merchant2.id}"
        pending
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq merchant2.id
        expect( output['name'] ).to eq merchant2.name
      end
    end

    context "given name='Jumpstart%20Lab'" do
      it "finds the merchant" do
        get "/merchants/find?name=Jumpstart%20Lab"
        pending
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq merchant1.id
        expect( output['name'] ).to eq merchant1.name
      end
    end

    context "given name='Galvanize'" do
      it "finds all merchants by name" do
        pending
        get "/merchants/find_all?name=Galvanize"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 2
      end
    end

    context "given id=1" do
      it "finds all merchants by id" do
        pending
        get "merchants/find_all?id=1"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 1
      end
    end
  end

  describe "relationships" do
    context "given a specific merchant id" do
      it "returns a collection of items associated with the merchant" do
        pending
        SalesEngineWeb::Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 2)
        SalesEngineWeb::Item.create(:name => "paddle", :description => "Yep, it's a paddle.", :unit_price => 10000, :merchant_id => 2)
        SalesEngineWeb::Item.create(:name => "sunglasses", :description => "Yep, they're sunglasses.", :unit_price => 1000, :merchant_id => 2)
        get "/merchants/2/items"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 3
      end

      it "returns a collection of invoices associated with the merchant" do
        pending
        SalesEngineWeb::Invoice.create(:customer_id => 1, :merchant_id => 3, :status => "shipped")
        SalesEngineWeb::Invoice.create(:customer_id => 2, :merchant_id => 3, :status => "shipped")
        get "/merchants/3/invoices"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 2
      end
    end
  end

  describe "business intelligence" do
    it "returns the top X merchants ranked by total revenue" do
      pending
    end

    it "returns the top X merchants ranked by total items sold" do
      pending
    end

    context "given a specific date" do
      it "returns the total revenue for that date across all merchants" do
        pending
      end
    end

    context "given a specific merchant" do
      it "returns the total revenue across all transactions" do
        pending
      end

      it "returns the total revenue for a specific invoice date" do
        pending
      end

      it "returns the customer with the most successful transactions" do
        pending
      end

      it "returns customers with pending invoices" do
        pending
      end
    end
  end
end