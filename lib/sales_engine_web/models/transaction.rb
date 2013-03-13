require './lib/sales_engine_web/models/database'

module SalesEngineWeb
  class Transaction
    attr_reader :id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result

    def initialize(params)
      @id = params[:id]
      @invoice_id = params[:invoice_id]
      @credit_card_number = params[:credit_card_number]
      @credit_card_expiration_date = params[:credit_card_expiration_date]
      @result = params[:result]
    end

    def self.create(params)
      Transaction.new(params).save
    end

    def save
      @id = Transaction.add(self)
      self
    end

    def self.add(transaction)
      transactions.insert(transaction.to_hash)
    end

    def to_hash
      { :id => id, :invoice_id => invoice_id, :credit_card_number => credit_card_number, :credit_card_expiration_date => credit_card_expiration_date, :result => result }
    end

    def self.find_by_id(id)
      result = transactions.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_all_by_id(id)
      results = transactions.where(:id => id.to_i).to_a
      results.each {|r| new(r) if r}
    end

    def self.find_by_invoice_id(invoice_id)
      result = transactions.where(:invoice_id => invoice_id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_all_by_invoice_id(invoice_id)
      results = transactions.where(:invoice_id => invoice_id.to_i).to_a
      results.each {|r| new(r) if r}
    end

    def self.find_by_credit_card_number(credit_card_number)
      result = transactions.where(:credit_card_number => credit_card_number.to_i).limit(1).first
      new(result) if result
    end

    def self.find_all_by_credit_card_number(credit_card_number)
      results = transactions.where(:credit_card_number => credit_card_number.to_i).to_a
      results.each {|r| new(r) if r}
    end

    def self.find_by_result(result)
      resultt = transactions.limit(1).where(Sequel.ilike(:result, "%#{result}%")).first
      new(resultt) if resultt
    end

    def self.find_all_by_result(result)
      results = transactions.where(Sequel.ilike(:result, "%#{result}%")).to_a
      results.each {|r| new(r) if r}
    end

    def to_json
      {:id => id, :invoice_id => invoice_id, :credit_card_number => credit_card_number, :credit_card_expiration_date => credit_card_expiration_date, :result => result}.to_json
    end

    def self.random
      result = transactions.to_a.sample
      new(result) if result
    end

    def self.transactions
      Database.transactions
    end

    def invoice
      Invoice.find_by_id(invoice_id)
    end
  end
end