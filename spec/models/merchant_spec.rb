require 'spec_helper'
require 'date'

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
          Invoice.create(:customer_id => 1, :merchant_id => 2, :status => "shipped", :created_at => "2012-03-25 09:54:09 UTC")
          Invoice.create(:customer_id => 2, :merchant_id => 2, :status => "shipped", :created_at => "2012-03-25 09:54:09 UTC")
          expect( target2.invoices.count ).to eq 2
        end
      end
    end

    describe "individual merchant revenue" do
      let!(:invoice1){ Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped", :created_at => (Date.parse("2012-03-25 09:54:09 UTC").strftime("%Y-%m-%d"))) }
      let!(:invoice2){ Invoice.create(:customer_id => 2, :merchant_id => 2, :status => "shipped", :created_at => (Date.parse("2012-03-25 09:54:09 UTC").strftime("%Y-%m-%d"))) }
      let!(:invoice3){ Invoice.create(:customer_id => 2, :merchant_id => 2, :status => "shipped", :created_at => (Date.parse("2012-03-24 09:54:09 UTC").strftime("%Y-%m-%d"))) }
      let!(:invoice_item1){ InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 20000) }
      let!(:invoice_item2){ InvoiceItem.create(:item_id => 1, :invoice_id => 2, :quantity => 5, :unit_price => 10000) }
      let!(:invoice_item3){ InvoiceItem.create(:item_id => 1, :invoice_id => 2, :quantity => 1, :unit_price => 10000) }
      let!(:invoice_item4){ InvoiceItem.create(:item_id => 1, :invoice_id => 3, :quantity => 1, :unit_price => 10000) }
      let!(:transaction1){ Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success") }
      let!(:transaction2){ Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "failed") }
      let!(:transaction3){ Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success") }
      let!(:transaction4){ Transaction.create(:invoice_id => 3, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success") }

      it "calculates revenue for a merchant across all dates" do
        expect( target2.revenue ).to eq 70000
      end

      it "calculates revenue a merchant for a specific date" do
        expect( target2.revenue_for_date("2012-03-25") ).to eq 60000
      end
    end

    describe "pending invoices" do
      it "returns customers with pending invoices" do
        Customer.create(:first_name => "Lola May", :last_name => "Drummond")
        Customer.create(:first_name => "Erin", :last_name => "Drummond")
        Customer.create(:first_name => "Brock", :last_name => "Drummond")
        Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped", :created_at => (Date.parse("2012-03-25 09:54:09 UTC").strftime("%Y-%m-%d")))
        Invoice.create(:customer_id => 2, :merchant_id => 1, :status => "shipped", :created_at => (Date.parse("2012-03-25 09:54:09 UTC").strftime("%Y-%m-%d")))
        Invoice.create(:customer_id => 3, :merchant_id => 1, :status => "shipped", :created_at => (Date.parse("2012-03-24 09:54:09 UTC").strftime("%Y-%m-%d")))
        Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "failed")
        Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "failed")
        Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        Transaction.create(:invoice_id => 3, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "failed")
        expect( target.customers_with_pending_invoices.count ).to eq 2
      end
    end
  end
end