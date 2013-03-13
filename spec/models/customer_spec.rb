require 'spec_helper'

module SalesEngineWeb
  describe Customer do
    describe "create" do
      it "creates a customer" do
        customer = Customer.create(:first_name => "Jeff", :last_name => "Casimir")
        expect( customer.last_name ).to eq "Casimir"
        expect( customer.first_name).to eq "Jeff"
      end
    end

    describe "find" do
      it "finds a customer with the specified id" do
        target = Customer.create(:first_name => "Lola May", :last_name => "Drummond")
        found = Customer.find_by_id(target.id)
        expect( found.id ).to eq target.id
        expect( found.first_name ).to eq target.first_name
        expect( found.last_name ).to eq target.last_name
      end

      it "finds a customer with the specified first name" do
        target = Customer.create(:first_name => "Lola May", :last_name => "Drummond")
        found = Customer.find_by_first_name( target.first_name )
        expect( found.id ).to eq target.id
        expect( found.first_name).to eq "Lola May"
        expect( found.last_name).to eq "Drummond"
      end

      it "finds a customer with the specified last name" do
        target = Customer.create(:first_name => "Lola May", :last_name => "Drummond")
        found = Customer.find_by_last_name( target.last_name )
        expect( found.id ).to eq target.id
        expect( found.first_name).to eq "Lola May"
        expect( found.last_name).to eq "Drummond"
      end

      it "finds a customer with the specified last name, case insensitive" do
        target = Customer.create(:first_name => "Lola May", :last_name => "Drummond")
        found = Customer.find_by_last_name( "drummond" )
        expect( found.id ).to eq target.id
        expect( found.first_name).to eq "Lola May"
        expect( found.last_name).to eq "Drummond"
      end

      it "finds all customers with a specified id" do
        target = Customer.create(:first_name => "Lola May", :last_name => "Drummond")
        findings = Customer.find_all_by_id(1)
        expect( findings.count ).to eq 1
        expect( findings).to be_a_kind_of(Array)
      end

      it "finds all customers with a specified first name" do
        target1 = Customer.create(:first_name => "Lola May", :last_name => "Drummond")
        target2 = Customer.create(:first_name => "Lola May", :last_name => "Boland")
        findings = Customer.find_all_by_first_name("Lola May")
        expect( findings.count ).to eq 2
      end

      it "finds all customers with a specified last name" do
        target1 = Customer.create(:first_name => "Lola May", :last_name => "Drummond")
        target2 = Customer.create(:first_name => "Erin", :last_name => "Drummond")
        findings = Customer.find_all_by_last_name("Drummond")
        expect( findings.count ).to eq 2
      end
    end

    describe "random" do
      it "returns a random customer instance" do
        Customer.create(:first_name => "Lola May", :last_name => "Drummond")
        Customer.create(:first_name => "Erin", :last_name => "Drummond")
        expect( Customer.random ).to be_a_kind_of(Customer)
      end
    end
  end
end