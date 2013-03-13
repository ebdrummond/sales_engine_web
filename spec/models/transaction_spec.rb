require 'spec_helper'

module SalesEngineWeb
  describe Transaction do
    describe '.create' do
      it 'creates a transaction' do
        transaction = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        expect( transaction.invoice_id ).to eq 1
        expect( transaction.credit_card_number ).to eq 4444444444444444
        expect( transaction.result ).to eq "success"
      end
    end

    describe 'find' do
      it "finds a transaction by id" do
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        found = Transaction.find_by_id(target.id)
        expect( found.id ).to eq target.id
        expect( found.invoice_id ).to eq target.invoice_id
        expect( found.credit_card_number ).to eq target.credit_card_number
      end

      it "finds a transaction by customer id" do
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        found = Transaction.find_by_invoice_id(target.invoice_id)
        expect( found.invoice_id ).to eq target.invoice_id
        expect( found.id ).to eq target.id
        expect( found.credit_card_number ).to eq target.credit_card_number
      end

      it "finds a transaction by merchant id" do
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        found = Transaction.find_by_credit_card_number(target.credit_card_number)
        expect( found.invoice_id ).to eq target.invoice_id
        expect( found.id ).to eq target.id
        expect( found.credit_card_number ).to eq target.credit_card_number
      end

      it "finds a transaction by result" do
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        found = Transaction.find_by_result(target.result)
        expect( found.invoice_id ).to eq target.invoice_id
        expect( found.id ).to eq target.id
        expect( found.credit_card_number ).to eq target.credit_card_number
      end

      it "finds all transactions by id" do
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        findings = Transaction.find_all_by_id(target.id)
        expect( findings.count ).to eq 1
      end

      it "finds all transactions by customer id" do
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        findings = Transaction.find_all_by_invoice_id(target.invoice_id)
        expect( findings.count ).to eq 2
      end

      it "finds all transactions by merchant id" do
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        findings = Transaction.find_all_by_credit_card_number(target.credit_card_number)
        expect( findings.count ).to eq 2
      end

      it "finds all transactions by result" do
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        findings = Transaction.find_all_by_result(target.result)
        expect( findings.count ).to eq 2
      end
    end

    describe "random" do
      it "returns a random transaction instance" do
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        target = Transaction.create(:invoice_id => 1, :credit_card_number => 4444444444444444, :credit_card_expiration_date => "", :result => "success")
        expect( Transaction.random ).to be_kind_of(Transaction)
      end
    end
  end
end