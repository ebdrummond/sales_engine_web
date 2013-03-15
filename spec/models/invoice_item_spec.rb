require 'spec_helper'

module SalesEngineWeb
  describe InvoiceItem do
    describe '.create' do
      it 'creates an invoice_item' do
        invoice_item = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        expect( invoice_item.item_id ).to eq 1
        expect( invoice_item.invoice_id ).to eq 1
        expect( invoice_item.quantity ).to eq 5
        expect( invoice_item.unit_price).to eq 10000
      end
    end

    describe 'find' do
      it "finds an invoice_item by id" do
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        found = InvoiceItem.find_by_id(target.id)
        expect( found.id ).to eq target.id
        expect( found.item_id ).to eq target.item_id
        expect( found.invoice_id ).to eq target.invoice_id
      end

      it "finds an invoice_item by item id" do
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        found = InvoiceItem.find_by_item_id(target.item_id)
        expect( found.item_id ).to eq target.item_id
        expect( found.id ).to eq target.id
        expect( found.invoice_id ).to eq target.invoice_id
      end

      it "finds an invoice_item by invoice id" do
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        found = InvoiceItem.find_by_invoice_id(target.invoice_id)
        expect( found.item_id ).to eq target.item_id
        expect( found.id ).to eq target.id
        expect( found.invoice_id ).to eq target.invoice_id
      end

      it "finds an invoice_item by quantity" do
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        found = InvoiceItem.find_by_quantity(target.quantity)
        expect( found.item_id ).to eq target.item_id
        expect( found.id ).to eq target.id
        expect( found.invoice_id ).to eq target.invoice_id
      end

      it "finds an invoice_item by unit price" do
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        found = InvoiceItem.find_by_unit_price(target.unit_price)
        expect( found.item_id ).to eq target.item_id
        expect( found.id ).to eq target.id
        expect( found.invoice_id ).to eq target.invoice_id
      end

      it "finds all invoice_items by id" do
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        target2 = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        findings = InvoiceItem.find_all_by_id(target.id)
        expect( findings.count ).to eq 1
      end

      it "finds all invoice_items by item id" do
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        target2 = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        findings = InvoiceItem.find_all_by_item_id(target.item_id)
        expect( findings.count ).to eq 2
      end

      it "finds all invoice_items by invoice id" do
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        target2 = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        findings = InvoiceItem.find_all_by_invoice_id(target.invoice_id)
        expect( findings.count ).to eq 2
      end

      it "finds all invoice_items by quantity" do
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        target2 = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        findings = InvoiceItem.find_all_by_quantity(target.quantity)
        expect( findings.count ).to eq 2
      end

      it "finds all invoice_items by unit price" do
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        target2 = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        findings = InvoiceItem.find_all_by_unit_price(target.unit_price)
        expect( findings.count ).to eq 2
      end
    end

    describe "random" do
      it "returns a random invoice_item instance" do
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
        expect( InvoiceItem.random ).to be_kind_of(InvoiceItem)
      end
    end

    describe "invoice" do
      context "given a specific invoice item" do
        it "returns the invoice associated with that invoice item" do
          invoice_item = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
          Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
          expect( invoice_item.invoice ).to be_an_instance_of(Invoice)
        end
      end
    end

    describe "item" do
      context "given a specific invoice item" do
        it "returns the item associated with that invoice item" do
          invoice_item = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
          Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 1)
          expect( invoice_item.item ).to be_an_instance_of(Item)
        end
      end
    end

    describe "subtotal" do
      context "given a specific invoice item" do
        it "returns the subtotal of unit price times quantity" do
          target = InvoiceItem.create(:item_id => 1, :invoice_id => 1, :quantity => 5, :unit_price => 10000)
          expect( target.subtotal ).to eq 50000
        end
      end
    end
  end
end