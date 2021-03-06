require 'spec_helper'

describe "/customers/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  before(:each) do
    customer1 && customer2 && customer3
  end

  let(:customer1){ SalesEngineWeb::Customer.create(:first_name => "Lola May", :last_name => "Drummond") }
  let(:customer2){ SalesEngineWeb::Customer.create(:first_name => "Erin", :last_name => "Drummond") }
  let(:customer3){ SalesEngineWeb::Customer.create(:first_name => "Erin", :last_name => "Andrews") }

  describe "find" do 
    context "given an existing id" do 
      it "finds the customer" do
        get "/customers/find?id=#{ customer2.id }"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq customer2.id
        expect( output['first_name'] ).to eq customer2.first_name
        expect( output['last_name'] ).to eq customer2.last_name
      end

      it "finds all customers associated with the id" do
        get "/customers/find_all?id=#{ customer1.id }"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 1
        expect( output ).to be_a_kind_of(Array)
      end
    end

    context "given an existing first name" do
      it "finds the customer" do 
        get "/customers/find?first_name=Lola%20May"
        output = JSON.parse(last_response.body)
        expect( output['first_name'] ).to eq "Lola May"
        expect( output['last_name'] ).to eq "Drummond"
      end

      it "finds the customer, case insensitive" do
        get "/customers/find?first_name=erin"
        output = JSON.parse(last_response.body)
        expect( output['first_name'] ).to eq "Erin"
      end

      it "finds all customers with the name" do
        get "customers/find_all?first_name=erin"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 2
      end
    end

    context "given an existing last name" do
      it "finds the customer" do 
        get "/customers/find?last_name=Andrews"
        output = JSON.parse(last_response.body)
        expect( output['first_name'] ).to eq "Erin"
        expect( output['last_name'] ).to eq "Andrews"
      end

      it "finds the customer, case insensitive" do
        get "/customers/find?last_name=andrews"
        output = JSON.parse(last_response.body)
        expect( output['first_name'] ).to eq "Erin"
        expect( output['last_name'] ).to eq "Andrews"
      end

      it "finds all customers with the name" do
        get "/customers/find_all?last_name=Drummond"
        output = JSON.parse(last_response.body)
        expect( output.count).to eq 2
      end
    end
  end

  describe "random" do
    it "returns a random customer instance" do
      get '/customers/random'
      output = JSON.parse(last_response.body)
      expect( [ customer1.id, customer2.id, customer3.id ] ).to include( output['id'] )
    end
  end

  describe "relationships" do
    context "given a specific customer" do
      it "returns a collection of associated invoices" do
        SalesEngineWeb::Invoice.create(:customer_id => 3, :merchant_id => 1, :status => "shipped", :created_at => "2012-03-25 09:54:09 UTC")
        SalesEngineWeb::Invoice.create(:customer_id => 3, :merchant_id => 1, :status => "shipped", :created_at => "2012-03-25 09:54:09 UTC")
        get "/customers/3/invoices"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 2
      end

      it "returns a collection of associated transactions" do
        SalesEngineWeb::Invoice.create(:customer_id => 3, :merchant_id => 1, :status => "shipped", :created_at => "2012-03-25 09:54:09 UTC")
        SalesEngineWeb::Invoice.create(:customer_id => 3, :merchant_id => 1, :status => "shipped", :created_at => "2012-03-25 09:54:09 UTC")
        SalesEngineWeb::Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        SalesEngineWeb::Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "super fail")
        SalesEngineWeb::Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        SalesEngineWeb::Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "never!", :result => "success")
        get "/customers/3/transactions"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 4
        expect( output[3].values ).to include("never!")
      end
    end
  end

  describe "business intelligence" do
    context "given a specific customer" do
      it "returns a merchant where the customer has conducted the most successful transactions" do
        SalesEngineWeb::Merchant.create(:name => "Jumpstart Lab")
        SalesEngineWeb::Merchant.create(:name => "gSchool")
        SalesEngineWeb::Merchant.create(:name => "Galvanize")
        SalesEngineWeb::Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped", :created_at => (Date.parse("2012-03-25 09:54:09 UTC").strftime("%Y-%m-%d")))
        SalesEngineWeb::Invoice.create(:customer_id => 2, :merchant_id => 1, :status => "shipped", :created_at => (Date.parse("2012-03-25 09:54:09 UTC").strftime("%Y-%m-%d")))
        SalesEngineWeb::Invoice.create(:customer_id => 3, :merchant_id => 1, :status => "shipped", :created_at => (Date.parse("2012-03-24 09:54:09 UTC").strftime("%Y-%m-%d")))
        SalesEngineWeb::Invoice.create(:customer_id => 3, :merchant_id => 2, :status => "shipped", :created_at => (Date.parse("2012-03-24 09:54:09 UTC").strftime("%Y-%m-%d")))
        SalesEngineWeb::Invoice.create(:customer_id => 3, :merchant_id => 3, :status => "shipped", :created_at => (Date.parse("2012-03-24 09:54:09 UTC").strftime("%Y-%m-%d")))
        SalesEngineWeb::Invoice.create(:customer_id => 3, :merchant_id => 3, :status => "shipped", :created_at => (Date.parse("2012-03-24 09:54:09 UTC").strftime("%Y-%m-%d")))
        SalesEngineWeb::Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        SalesEngineWeb::Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        SalesEngineWeb::Transaction.create(:invoice_id => 3, :credit_card_number => 5555555555555555, :credit_card_expiration_date => "", :result => "success")
        SalesEngineWeb::Transaction.create(:invoice_id => 4, :credit_card_number => 5555555555555555, :credit_card_expiration_date => "", :result => "failed")
        SalesEngineWeb::Transaction.create(:invoice_id => 5, :credit_card_number => 5555555555555555, :credit_card_expiration_date => "", :result => "success")
        SalesEngineWeb::Transaction.create(:invoice_id => 6, :credit_card_number => 5555555555555555, :credit_card_expiration_date => "", :result => "success")
        get "/customers/3/favorite_merchant"
        output = JSON.parse(last_response.body)
        expect( output['name'] ).to eq "Galvanize"
      end
    end
  end
end