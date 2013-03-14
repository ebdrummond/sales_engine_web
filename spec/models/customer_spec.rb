require 'spec_helper'

module SalesEngineWeb
  describe Customer do
    before do
      Customer.create(:first_name => "Lola May", :last_name => "Drummond")
      Customer.create(:first_name => "Lola May", :last_name => "Boland")
      Customer.create(:first_name => "Erin", :last_name => "Drummond")
    end

    let(:target1){Customer.find_by_first_name("Lola May")}
    let(:target2){Customer.find_by_first_name("Lola May")}
    let(:target3){Customer.find_by_first_name("Erin")}

    describe "create" do
      it "creates a customer" do
        expect( target1.last_name ).to eq "Drummond"
        expect( target1.first_name).to eq "Lola May"
      end
    end

    describe "find" do
      it "finds a customer with the specified id" do
        found = Customer.find_by_id(target1.id)
        expect( found.id ).to eq target1.id
        expect( found.first_name ).to eq target1.first_name
        expect( found.last_name ).to eq target1.last_name
      end

      it "finds a customer with the specified first name" do
        found = Customer.find_by_first_name( target1.first_name )
        expect( found.id ).to eq target1.id
        expect( found.first_name).to eq "Lola May"
        expect( found.last_name).to eq "Drummond"
      end

      it "finds a customer with the specified last name" do
        found = Customer.find_by_last_name( target1.last_name )
        expect( found.id ).to eq target1.id
        expect( found.first_name).to eq "Lola May"
        expect( found.last_name).to eq "Drummond"
      end

      it "finds a customer with the specified last name, case insensitive" do
        found = Customer.find_by_last_name( "drummond" )
        expect( found.id ).to eq target1.id
        expect( found.first_name).to eq "Lola May"
        expect( found.last_name).to eq "Drummond"
      end

      it "finds all customers with a specified id" do
        findings = Customer.find_all_by_id(1)
        expect( findings.count ).to eq 1
        expect( findings).to be_a_kind_of(Array)
      end

      it "finds all customers with a specified first name" do
        findings = Customer.find_all_by_first_name("Lola May")
        expect( findings.count ).to eq 2
      end

      it "finds all customers with a specified last name" do
        findings = Customer.find_all_by_last_name("Drummond")
        expect( findings.count ).to eq 2
      end
    end

    describe "random" do
      it "returns a random customer instance" do
        expect( Customer.random ).to be_a_kind_of(Customer)
      end
    end

    describe "invoices" do
      context "given a specifc customer" do
        it "finds the invoices associated with that customer" do
          Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped")
          Invoice.create(:customer_id => 2, :merchant_id => 3, :status => "shipped")
          Invoice.create(:customer_id => 2, :merchant_id => 1, :status => "shipped")
          expect( target2.invoices.count ).to eq 2
        end
      end
    end

    describe "transactions" do
      context "given a specific customer" do
        it "finds the transactions associated with that customer" do
          Invoice.create(:customer_id => 2, :merchant_id => 1, :status => "shipped")
          Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
          Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
          Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
          expect( target2.transactions.count ).to eq 3
        end
      end
    end
  end
end