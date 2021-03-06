require './lib/sales_engine_web/models/database'

module SalesEngineWeb

  class Customer
    attr_reader :id, :first_name, :last_name

    def initialize(params) 
      @id = params[:id]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
    end

    def self.create(params)
      Customer.new(params).save
    end

    def save
      @id = Customer.add(self)
      self
    end

    def self.add(customer)
      customers.insert(customer.to_hash)
    end

    def to_hash
      { :id => id, :first_name => first_name, :last_name => last_name }
    end

    def self.customers
      Database.customers
    end

    def self.find_by_id(id)
      result = customers.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_by_first_name(first_name)
      result = customers.limit(1).where(Sequel.ilike(:first_name, "%#{first_name}%")).first
      new(result) if result
    end

    def self.find_by_last_name(last_name)
      result = customers.limit(1).where(Sequel.ilike(:last_name, "%#{last_name}%")).first
      new(result) if result
    end

    def self.find_all_by_id(id)
      results = customers.where(:id => id.to_i).to_a
      results.collect {|r| new(r) if r}
    end

    def self.find_all_by_first_name(first_name)
      results = customers.where(Sequel.ilike(:first_name, "%#{first_name}%")).to_a
      results.collect {|r| new(r) if r}
    end

    def self.find_all_by_last_name(last_name)
      results = customers.where(Sequel.ilike(:last_name, "%#{last_name}%")).to_a
      results.collect {|r| new(r) if r}
    end

    def self.random
      result = customers.to_a.sample
      new(result) if result
    end

    def to_json(*args)
      {:id => id, :first_name => first_name, :last_name => last_name}.to_json
    end

    def invoices
      Invoice.find_all_by_customer_id(id)
    end

    def invoice_ids
      invoices.collect{|i| i.id}
    end

    def transactions
      Transaction.transactions.where(:invoice_id => invoice_ids).to_a
    end

    def paid_invoices
      invoices.select{|i| i.paid? }
    end

    def paid_invoices_by_merchant_ids
      paid_invoices_per_merchant = Hash.new(0)
      paid_invoices.inject(paid_invoices_per_merchant) do |hash, pi|
        hash[pi.merchant_id] += 1
        hash
      end
      paid_invoices_per_merchant
    end

    def id_of_favorite_merchant
      fav_merch = paid_invoices_by_merchant_ids.max_by{|k, v| v}
      fav_merch[0]
    end

    def favorite_merchant
      Merchant.find_by_id(id_of_favorite_merchant)
    end
  end
end

