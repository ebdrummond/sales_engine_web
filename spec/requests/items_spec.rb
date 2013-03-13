require 'spec_helper'

describe "/items/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  before(:each) do
    item1 && item2 && item3 && item4
  end

  let(:item1){ SalesEngineWeb::Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1) }
  let(:item2){ SalesEngineWeb::Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1) }
  let(:item3){ SalesEngineWeb::Item.create(:name => "paddle", :description => "Damn fine paddle.", :unit_price => 10000, :merchant_id => 1) }
  let(:item4){ SalesEngineWeb::Item.create(:name => "beer", :description => "Paddle responsibly.", :unit_price => 1000, :merchant_id => 2) }

  describe "find" do
    context "given an existing id" do
      it "finds an item" do
        get "/items/find?id=#{ item1.id }"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq item1.id
        expect( output['name'] ).to eq item1.name
        expect( output['description'] ).to eq item1.description
      end

      it "finds all items" do
        get "/items/find_all?id=1"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 1
      end
    end

    context "given an existing name" do
      it "finds an item" do
        get "/items/find?name=kayak"
        output = JSON.parse(last_response.body)
        expect( output['name'] ).to eq "kayak"
        expect( output['description'] ).to eq "Yep, it's a kayak."
      end

      it "finds an item, case insensitive" do
        get "/items/find?name=Beer"
        output = JSON.parse(last_response.body)
        expect( output['name'] ).to eq "beer"
        expect( output['merchant_id'] ).to eq 2
      end

      it "finds all items" do
        get "/items/find_all?name=kayak"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 2
      end
    end

    context "given an existing description" do
      it "finds an item" do
        get "items/find?description=Damn%20fine%20paddle"
        output = JSON.parse(last_response.body)
        expect( output['description'] ).to eq item3.description
        expect( output['name'] ).to eq item3.name
      end

      it "finds an item, case insensitive" do
        get "items/find?description=Damn%20Fine%20PADDLE"
        output = JSON.parse(last_response.body)
        expect( output['description'] ).to eq "Damn fine paddle."
        expect( output['name'] ).to eq "paddle"
      end

      it "finds all items" do
        get "items/find_all?description=yep,%20it's%20a%20kayak"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 2
      end
    end

    context "given an existing unit price" do
      it "finds an item" do
        get "/items/find?unit_price=1000"
        output = JSON.parse(last_response.body)
        expect( output['name'] ).to eq "beer"
        expect( output['merchant_id'] ).to eq 2
      end

      it "finds all items" do
        get "/items/find_all?unit_price=80000"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 2
      end
    end

    context "given an existing merchant id" do
      it "finds an item" do
        get "/items/find?merchant_id=2"
        output = JSON.parse(last_response.body)
        expect( output['name'] ).to eq "beer"
        expect( output['merchant_id'] ).to eq 2
      end

      it "finds all items" do
        get "/items/find_all?merchant_id=1"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 3
      end
    end
  end

  describe "random" do
    it "returns a random items instance" do
      get "items/random"
      output = JSON.parse(last_response.body)
      expect( [ item1.id, item2.id, item3.id, item4.id ] ).to include( output['id'] )
    end
  end

  describe "relationships" do
    context "given a specific item" do
      it "returns a collection of associated invoice items" do
        SalesEngineWeb::InvoiceItem.create(:item_id => 1, :invoice_id => 3, :quantity => 5, :unit_price => 10000)
        SalesEngineWeb::InvoiceItem.create(:item_id => 1, :invoice_id => 3, :quantity => 5, :unit_price => 10000)
        get "/items/1/invoice_items"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 2
      end

      it "returns a collection of associated merchants" do
        pending
      end
    end
  end

  describe "business intelligence" do
    it "returns the top X items ranked by total revenue generated" do
      pending
    end

    it "returns the top X items ranked by total number sold" do
      pending
    end

    context "given a specific date" do
      it "returns the best selling item for that date" do
      end
    end
  end
end