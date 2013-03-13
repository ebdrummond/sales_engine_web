require './lib/sales_engine_web/models/database'

module SalesEngineWeb
  class Invoice
    attr_reader :id, :customer_id, :merchant_id, :status

    def initialize(params)
      @id = params[:id]
      @customer_id = params[:customer_id]
      @merchant_id = params[:merchant_id]
      @status = params[:status]
    end

    def self.create(params)
      Invoice.new(params).save
    end

    def save
      @id = Invoice.add(self)
      self
    end

    def self.add(invoice)
      invoices.insert(invoice.to_hash)
    end

    def to_hash
      { :id => id, :customer_id => customer_id, :merchant_id => merchant_id, :status => status }
    end

    def self.invoices
      Database.invoices
    end

    def self.find_by_id(id)
      result = invoices.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_by_merchant_id(merchant_id)
      result = invoices.where(:merchant_id => merchant_id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_by_customer_id(customer_id)
      result = invoices.where(:customer_id => customer_id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_by_status(status)
      result = invoices.where(:status => status).limit(1).first
      new(result) if result
    end

    def self.find_all_by_id(id)
      results = invoices.where(:id => id.to_i).to_a
      results.each {|r| new(r) if r}
    end

    def self.find_all_by_customer_id(customer_id)
      results = invoices.where(:customer_id => customer_id.to_i).to_a
      results.each {|r| new(r) if r}
    end

    def self.find_all_by_merchant_id(merchant_id)
      results = invoices.where(:merchant_id => merchant_id.to_i).to_a
      results.each {|r| new(r) if r}
    end

    def self.find_all_by_status(status)
      results = invoices.where(Sequel.ilike(:status, "%#{status}%")).to_a
      results.each {|r| new(r) if r}
    end

    def self.random
      result = invoices.to_a.sample
      new(result) if result
    end

    def to_json
      {:id => id, :customer_id => customer_id, :merchant_id => merchant_id, :status => status}.to_json
    end

    def transactions
      Transaction.find_all_by_invoice_id(id)
    end

    def invoice_items
      InvoiceItem.find_all_by_invoice_id(id)
    end

    def items
      item_ids = invoice_items.collect{|ii| ii[item_id] }
      item_ids.each{|item_id| Item.find_all_by_id(item_id) }
    end

    def customer
      Customer.find_by_id(customer_id)
    end

    def merchant
      Merchant.find_by_id(merchant_id)
    end
  end
end