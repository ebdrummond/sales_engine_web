require 'spec_helper'

module SalesEngineWeb
  describe Merchant do

    let!(:target){ Merchant.create(:name => "Jumpstart Lab") }
    let!(:target2){ Merchant.create(:name => "Jumpstart Lab") }


    describe '.create' do
      it 'creates a merchant' do
        expect( target.name ).to eq "Jumpstart Lab"
      end
    end

    describe '.find' do
      it "finds a merchant by id" do
        found  = Merchant.find_by_id( target.id )
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end

      it "finds a merchant by name" do
        found  = Merchant.find_by_name("Jumpstart Lab")
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end

      it "finds by name, case insensitive" do
        found  = Merchant.find_by_name("jumpstart lab")
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end

      it "finds all merchants with a specified id" do
        findings = Merchant.find_all_by_id(1)
        expect( findings.count ).to eq 1
        expect( findings ).to be_a_kind_of(Array)
      end

      it "finds all merchants with a specified name" do
        findings = Merchant.find_all_by_name("Jumpstart lab")
        expect( findings.count ).to eq 2
      end
    end

    describe ".random" do
      it "returns a merchant" do
        expect( Merchant.random ).to be_kind_of(Merchant)
      end
    end

    describe "items" do
      context "given a specific merchant" do
        it "finds the items associated with that merchant" do
          Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 2)
          Item.create(:name => "paddle", :description => "Yep, it's a paddle.", :unit_price => 10000, :merchant_id => 2)
          Item.create(:name => "sunglasses", :description => "Yep, they're sunglasses.", :unit_price => 1000, :merchant_id => 2)
          expect( target2.items.count ).to eq 3
        end
      end
    end

    describe "invoices" do
      context "given a specific merchant" do
        it "finds the invoices associated with that merchant" do
          Invoice.create(:customer_id => 1, :merchant_id => 2, :status => "shipped")
          Invoice.create(:customer_id => 2, :merchant_id => 2, :status => "shipped")
          expect( target2.invoices.count ).to eq 2
        end
      end
    end

    describe "individual merchant revenue" do
      let!(:invoice1){ Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped") }
      let!(:invoice2){ Invoice.create(:customer_id => 2, :merchant_id => 2, :status => "shipped") }
      let!(:invoice_item1){ InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 20000) }
      let!(:invoice_item2){ InvoiceItem.create(:item_id => 1, :invoice_id => 2, :quantity => 5, :unit_price => 10000) }
      let!(:transaction1){ Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success") }
      let!(:transaction2){ Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "failed") }
      let!(:transaction3){ Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success") }

      it "calculates revenue for a merchant across all dates" do
        expect( target2.revenue ).to eq 50000
      end

      it "calculates revenue a merchant for a specific date" do
        pending
      end
    end
  end
end