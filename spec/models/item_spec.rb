require 'spec_helper'

module SalesEngineWeb
  describe Item do
    describe '.create' do
      it 'creates an item' do
        item = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        expect( item.name ).to eq "kayak"
      end
    end

    describe 'find' do
      it "finds an item by id" do
        target = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        found = Item.find_by_id( target.id )
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end

      it "finds all items by id" do
        target = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        findings = Item.find_all_by_id(1)
        expect( findings.count ).to eq 1
      end

      it "finds an item by name" do
        target = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        found = Item.find_by_name( target.name )
        expect( found.name ).to eq target.name
        expect( found.description ).to eq target.description
      end

      it "finds all items by name" do
        target = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        target2 = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)        
        findings = Item.find_all_by_name( "kayak" )
        expect( findings.count ).to eq 2
        expect( findings ).to be_a_kind_of(Array)
      end

      it "finds an item by description" do
        target = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        found = Item.find_by_description( target.description )
        expect( found.name ).to eq target.name
        expect( found.description ).to eq target.description
      end

      it "finds all items by description" do
        target = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        target2 = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)        
        findings = Item.find_all_by_description( "yep, it's a kayak" )
        expect( findings.count ).to eq 2
        expect( findings ).to be_a_kind_of(Array)
      end

      it "finds an item by unit price" do
        target = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        found = Item.find_by_unit_price( target.unit_price )
        expect( found.name ).to eq target.name
        expect( found.description ).to eq target.description
        expect( found.unit_price).to eq target.unit_price
      end

      it "finds all items by unit price" do
        target = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        target2 = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        findings = Item.find_all_by_unit_price( target.unit_price )
        expect( findings.count).to eq 2
      end

      it "finds an item by merchant id" do
        target = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        found = Item.find_by_merchant_id( target.merchant_id )
        expect( found.name ).to eq target.name
        expect( found.description ).to eq target.description
        expect( found.merchant_id).to eq target.merchant_id
      end

      it "finds all items by merchant id" do
        target = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        target2 = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        findings = Item.find_all_by_merchant_id( target.merchant_id )
        expect( findings.count).to eq 2
      end
    end

    describe "random" do
      it "returns an item" do
        Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
        expect( Item.random ).to be_kind_of(Item)
      end
    end

    describe "invoice items" do
      context "given a specifc invoice" do
        it "finds the invoice items associated with that invoice" do
          Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
          item = Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
          InvoiceItem.create(:item_id => 2, :invoice_id => 2, :quantity => 5, :unit_price => 10000)
          InvoiceItem.create(:item_id => 2, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
          InvoiceItem.create(:item_id => 1, :invoice_id => 2, :quantity => 5, :unit_price => 10000)
          expect( item.invoice_items.count ).to eq 2
        end
      end
    end
  end
end