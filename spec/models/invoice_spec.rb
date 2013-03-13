require 'spec_helper'

module SalesEngineWeb
  describe Invoice do
    describe '.create' do
      it 'creates an invoice' do
        invoice = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        expect( invoice.customer_id ).to eq 1
        expect( invoice.merchant_id ).to eq 1
        expect( invoice.status ).to eq "shipped"
      end
    end

    describe 'find' do
      it "finds an invoice by id" do
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        found = Invoice.find_by_id(target.id)
        expect( found.id ).to eq target.id
        expect( found.customer_id ).to eq target.customer_id
        expect( found.merchant_id ).to eq target.merchant_id
      end

      it "finds an invoice by customer id" do
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        found = Invoice.find_by_customer_id(target.customer_id)
        expect( found.customer_id ).to eq target.customer_id
        expect( found.id ).to eq target.id
        expect( found.merchant_id ).to eq target.merchant_id
      end

      it "finds an invoice by merchant id" do
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        found = Invoice.find_by_merchant_id(target.merchant_id)
        expect( found.customer_id ).to eq target.customer_id
        expect( found.id ).to eq target.id
        expect( found.merchant_id ).to eq target.merchant_id
      end

      it "finds an invoice by status" do
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        found = Invoice.find_by_status(target.status)
        expect( found.customer_id ).to eq target.customer_id
        expect( found.id ).to eq target.id
        expect( found.merchant_id ).to eq target.merchant_id
      end

      it "finds all invoices by id" do
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        findings = Invoice.find_all_by_id(target.id)
        expect( findings.count ).to eq 1
      end

      it "finds all invoices by customer id" do
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        findings = Invoice.find_all_by_customer_id(target.customer_id)
        expect( findings.count ).to eq 2
      end

      it "finds all invoices by merchant id" do
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        findings = Invoice.find_all_by_merchant_id(target.merchant_id)
        expect( findings.count ).to eq 2
      end

      it "finds all invoices by status" do
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        findings = Invoice.find_all_by_status(target.status)
        expect( findings.count ).to eq 2
      end
    end

    describe "random" do
      it "returns a random invoice instance" do
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        target = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
        expect( Invoice.random ).to be_kind_of(Invoice)
      end
    end

    describe "transactions" do
      context "given a specifc invoice" do
        it "finds the transactions associated with that invoice" do
          Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
          invoice = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
          Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
          Transaction.create(:invoice_id => 2, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
          Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
          expect( invoice.transactions.count ).to eq 2
        end
      end
    end

    describe "invoice items" do
      context "given a specifc invoice" do
        it "finds the invoice items associated with that invoice" do
          Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
          invoice = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
          InvoiceItem.create(:item_id => 1, :invoice_id => 2, :quantity => 5, :unit_price => 10000)
          InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
          InvoiceItem.create(:item_id => 1, :invoice_id => 2, :quantity => 5, :unit_price => 10000)
          expect( invoice.invoice_items.count ).to eq 2
        end
      end
    end

    describe "customer" do
      context "given a specific invoice" do
        it "finds the customer associated with that invoice" do
          invoice = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
          Customer.create(:first_name => "Lola May", :last_name => "Drummond")
          expect( invoice.customer ).to be_an_instance_of(Customer)
        end
      end
    end

    describe "merchant" do
      context "given a specific invoice" do
        it "finds the merchant associated with that invoice" do
          invoice = Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
          Merchant.create(:name => "Jumpstart Lab")
          expect( invoice.merchant ).to be_an_instance_of(Merchant)
        end
      end
    end
  end
end