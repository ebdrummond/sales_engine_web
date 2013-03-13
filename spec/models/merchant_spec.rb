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
      it "finds a merchant" do
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
  end
end