require 'spec_helper'

module SalesEngineWeb
  describe Merchant do
    describe '.create' do
      it 'creates a merchant' do
        merchant = Merchant.create(:name => "Jumpstart Lab")
        expect( merchant.name ).to eq "Jumpstart Lab"
      end
    end

    describe '.find' do
      it "finds a merchant by id" do
        target = Merchant.create(:name => "Jumpstart Lab")
        found  = Merchant.find_by_id( target.id )
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end

      it "finds a merchant by name" do
        target = Merchant.create(:name => "Jumpstart Lab")
        found  = Merchant.find_by_name("Jumpstart Lab")
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end

      it "finds by name, case insensitive" do
        target = Merchant.create(:name => "Jumpstart Lab")
        found  = Merchant.find_by_name("jumpstart lab")
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end

      it "finds all merchants with a specified id" do
        target = Merchant.create(:name => "Jumpstart Lab")
        findings = Merchant.find_all_by_id(1)
        expect( findings.count ).to eq 1
        expect( findings).to be_a_kind_of(Array)
      end

      it "finds all merchants with a specified last name" do
        target = Merchant.create(:name => "Jumpstart Lab")
        target2 = Merchant.create(:name => "Jumpstart Lab")
        findings = Merchant.find_all_by_name("Jumpstart lab")
        expect( findings.count ).to eq 2
      end
    end

    describe ".random" do
      it "returns a merchant" do
        Merchant.create(:name => "Jumpstart Lab")
        expect( Merchant.random ).to be_kind_of(Merchant)
      end
    end

    describe "items" do
      context "given a specific merchant" do
        it "finds the items associated with that merchant" do
          Merchant.create(:name => "gSchool")
          merchant = Merchant.create(:name => "Jumpstart Lab")
          Item.create(:name => "kayak", :description => "Yep, it's a kayak.", :unit_price => 80000, :merchant_id => 2)
          Item.create(:name => "paddle", :description => "Yep, it's a paddle.", :unit_price => 10000, :merchant_id => 2)
          Item.create(:name => "sunglasses", :description => "Yep, they're sunglasses.", :unit_price => 1000, :merchant_id => 2)
          expect( merchant.items.count ).to eq 3
        end
      end
    end

    describe "invoices" do
      context "given a specifc merchant" do
        it "finds the invoices associated with that merchant" do
          Merchant.create(:name => "gSchool")
          merchant = Merchant.create(:name => "Jumpstart Lab")
          Invoice.create(:customer_id => 1, :merchant_id => 2, :status => "shipped")
          Invoice.create(:customer_id => 2, :merchant_id => 2, :status => "shipped")
          expect( merchant.invoices.count ).to eq 2
        end
      end
    end
  end
end