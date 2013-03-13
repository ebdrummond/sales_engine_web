require 'spec_helper'

describe "/invoice items/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  before(:each) do
    invoice_item1 && invoice_item2 && invoice_item3 && invoice_item4
  end

  let(:invoice_item1){ SalesEngineWeb::InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000) }
  let(:invoice_item2){ SalesEngineWeb::InvoiceItem.create(:item_id => 2, :invoice_id => 2, :quantity => 10, :unit_price => 20000) }
  let(:invoice_item3){ SalesEngineWeb::InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000) }
  let(:invoice_item4){ SalesEngineWeb::InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000) }

  describe "find" do
    context "given an existing id" do
      it "finds an invoice item" do
        get "/invoice_items/find?id=#{ invoice_item1.id }"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq invoice_item1.id
        expect( output['item_id'] ).to eq invoice_item1.item_id
      end

      it "finds all invoice items" do
        get "/invoice_items/find_all?id=1"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 1
      end
    end

    context "given an existing item id" do
      it "finds an invoice item" do
        get "/invoice_items/find?item_id=#{ invoice_item1.item_id }"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq invoice_item1.id
        expect( output['item_id'] ).to eq invoice_item1.item_id
      end

      it "finds all invoice items" do
        get "/invoice_items/find_all?item_id=1"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 3
      end
    end

    context "given an existing invoice id" do
      it "finds an invoice item" do
        get "/invoice_items/find?invoice_id=#{ invoice_item1.invoice_id }"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq invoice_item1.id
        expect( output['invoice_id'] ).to eq invoice_item1.invoice_id
      end

      it "finds all invoice items" do
        get "/invoice_items/find_all?invoice_id=1"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 3
      end
    end

    context "given an existing quantity" do
      it "finds an invoice item" do
        get "/invoice_items/find?quantity=#{ invoice_item1.quantity }"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq invoice_item1.id
        expect( output['quantity'] ).to eq invoice_item1.quantity
      end

      it "finds all invoice items" do
        get "/invoice_items/find_all?quantity=5"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 3
      end
    end

    context "given an existing unit price" do
      it "finds an invoice item" do
        get "/invoice_items/find?unit_price=#{ invoice_item1.unit_price }"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq invoice_item1.id
        expect( output['unit_price'] ).to eq invoice_item1.unit_price
      end

      it "finds all invoice items" do
        get "/invoice_items/find_all?unit_price=20000"
        output = JSON.parse(last_response.body)
        expect( output.count ).to eq 1
      end
    end
  end

  describe "random" do
    it "returns a random invoice item instance" do
      get "invoice_items/random"
      output = JSON.parse(last_response.body)
      expect( [ invoice_item1.id, invoice_item2.id, invoice_item3.id, invoice_item4.id ] ).to include( output['id'] )
    end
  end

  describe "relationships" do
    context "given a specific invoice item" do
      it "returns the associated invoice" do
        pending
      end

      it "returns the associated items" do
        pending
      end
    end
  end
end