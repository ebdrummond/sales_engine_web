require 'spec_helper'

module SalesEngineWeb
  describe Transaction do

    let!(:target){ Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success") }
    let!(:target2){ Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success") }
    let!(:target3){ Transaction.create(:invoice_id => 111, :credit_card_number => 555555555555555, :credit_card_expiration_date => "", :result => "failed") }


    describe '.create' do
      it 'creates a transaction' do
        expect( target.invoice_id ).to eq 1
        expect( target.credit_card_number ).to eq 4444444444444444
        expect( target.result ).to eq "success"
      end
    end

    describe 'find' do
      it "finds a transaction by id" do
        found = Transaction.find_by_id(target.id)
        expect( found.id ).to eq target.id
        expect( found.invoice_id ).to eq target.invoice_id
        expect( found.credit_card_number ).to eq target.credit_card_number
      end

      it "finds a transaction by customer id" do
        found = Transaction.find_by_invoice_id(target.invoice_id)
        expect( found.invoice_id ).to eq target.invoice_id
        expect( found.id ).to eq target.id
        expect( found.credit_card_number ).to eq target.credit_card_number
      end

      it "finds a transaction by merchant id" do
        found = Transaction.find_by_credit_card_number(target.credit_card_number)
        expect( found.invoice_id ).to eq target.invoice_id
        expect( found.id ).to eq target.id
        expect( found.credit_card_number ).to eq target.credit_card_number
      end

      it "finds a transaction by result" do
        found = Transaction.find_by_result(target.result)
        expect( found.invoice_id ).to eq target.invoice_id
        expect( found.id ).to eq target.id
        expect( found.credit_card_number ).to eq target.credit_card_number
      end

      it "finds all transactions by id" do
        findings = Transaction.find_all_by_id(target.id)
        expect( findings.count ).to eq 1
        expect( findings ).to be_kind_of(Array)
      end

      it "finds all transactions by customer id" do
        findings = Transaction.find_all_by_invoice_id(target.invoice_id)
        expect( findings.count ).to eq 2
      end

      it "finds all transactions by merchant id" do
        findings = Transaction.find_all_by_credit_card_number(target.credit_card_number)
        expect( findings.count ).to eq 2
      end

      it "finds all transactions by result" do
        findings = Transaction.find_all_by_result(target.result)
        expect( findings.count ).to eq 2
      end
    end

    describe "random" do
      it "returns a random transaction instance" do
        expect( Transaction.random ).to be_kind_of(Transaction)
      end
    end

    describe "invoice" do
      context "given a specific transaction" do
        it "returns the associated invoice" do
          Invoice.create(:customer_id => 1, :merchant_id => 1, :status => "shipped", :created_at => "2012-03-25 09:54:09 UTC")
          expect( target.invoice ).to be_kind_of(Invoice)
        end
      end
    end

    describe "successful transactions" do
      it "returns only successful transactions" do
        expect( target.successful? ).to be_true
        expect( target3.successful? ).to be_false
      end
    end
  end
end