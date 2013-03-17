require 'spec_helper'

module SalesEngineWeb
  describe Invoice do

    let!(:target){Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")}
    let!(:target2){Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")}
    let!(:target3){Invoice.create(:customer_id => 111, :merchant_id => 111, :status => "lost")}

    describe '.create' do
      it 'creates an invoice' do
        expect( target.customer_id ).to eq 1
        expect( target.merchant_id ).to eq 1
        expect( target.status ).to eq "shipped"
      end
    end

    describe 'find' do
      it "finds an invoice by id" do
        found = Invoice.find_by_id(target.id)
        expect( found.id ).to eq target.id
        expect( found.customer_id ).to eq target.customer_id
        expect( found.merchant_id ).to eq target.merchant_id
      end

      it "finds an invoice by customer id" do
        found = Invoice.find_by_customer_id(target.customer_id)
        expect( found.customer_id ).to eq target.customer_id
        expect( found.id ).to eq target.id
        expect( found.merchant_id ).to eq target.merchant_id
      end

      it "finds an invoice by merchant id" do
        found = Invoice.find_by_merchant_id(target.merchant_id)
        expect( found.customer_id ).to eq target.customer_id
        expect( found.id ).to eq target.id
        expect( found.merchant_id ).to eq target.merchant_id
      end

      it "finds an invoice by status" do
        found = Invoice.find_by_status(target.status)
        expect( found.customer_id ).to eq target.customer_id
        expect( found.id ).to eq target.id
        expect( found.merchant_id ).to eq target.merchant_id
      end

      it "finds all invoices by id" do
        findings = Invoice.find_all_by_id(target.id)
        expect( findings.count ).to eq 1
      end

      it "finds all invoices by customer id" do
        findings = Invoice.find_all_by_customer_id(target.customer_id)
        expect( findings.count ).to eq 2
      end

      it "finds all invoices by merchant id" do
        findings = Invoice.find_all_by_merchant_id(target.merchant_id)
        expect( findings.count ).to eq 2
      end

      it "finds all invoices by status" do
        findings = Invoice.find_all_by_status(target.status)
        expect( findings.count ).to eq 2
      end
    end

    describe "random" do
      it "returns a random invoice instance" do
        expect( Invoice.random ).to be_kind_of(Invoice)
      end
    end

    describe "transactions" do
      context "given a specifc invoice" do
        it "finds the transactions associated with that invoice" do
          Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
          Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
          Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
          expect( target2.transactions.count ).to eq 2
        end
      end
    end

    describe "invoice items" do
      context "given a specifc invoice" do
        it "finds the invoice items associated with that invoice" do
          InvoiceItem.create(:item_id => 1, :invoice_id => 2, :quantity => 5, :unit_price => 10000)
          InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
          InvoiceItem.create(:item_id => 1, :invoice_id => 2, :quantity => 5, :unit_price => 10000)
          expect( target2.invoice_items.count ).to eq 2
        end
      end
    end

    describe "items" do
      let!(:item){Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)}
      let!(:item2){Item.create(:name => "kayak", :description => "Yep, it's a kayakity yak.", :unit_price => 80000, :merchant_id => 1)}
      let!(:inv_it){InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)}
      let!(:inv_it2){InvoiceItem.create(:item_id => 2, :invoice_id => 1, :quantity => 5, :unit_price => 10000)}
      
      context "given a specific invoice" do
        it "finds the item ids of the items associated with that invoice" do
          expect( target.item_ids ).to be_a_kind_of(Array)
          expect( target.item_ids ).to eq([1, 2])
        end

        it "finds the items associated with that invoice" do
          expect( target.items.count ).to eq 2
        end
      end
    end

    describe "customer" do
      context "given a specific invoice" do
        it "finds the customer associated with that invoice" do
          Customer.create(:first_name => "Lola May", :last_name => "Drummond")
          expect( target.customer ).to be_an_instance_of(Customer)
        end
      end
    end

    describe "merchant" do
      context "given a specific invoice" do
        it "finds the merchant associated with that invoice" do
          Merchant.create(:name => "Jumpstart Lab")
          expect( target.merchant ).to be_an_instance_of(Merchant)
        end
      end
    end

    describe "paid invoices" do
      context "given a specific invoice" do
        it "returns whether the invoice was paid (successful)" do
          Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "failed")
          Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
          Transaction.create(:invoice_id => 2, :credit_card_number => 5555555555555555, :credit_card_expiration_date => "", :result => "failed")
          expect( target.paid? ).to be_false
          expect( target2.paid? ).to be_true
        end
      end
    end

    describe "total" do
      context "given a specific invoice" do
        it "returns the total amount" do
          Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
          InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
          InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
          expect( target.total ).to eq 100000
        end
      end
    end
  end
end