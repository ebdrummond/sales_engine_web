require './lib/sales_engine_web/models/database'
require 'date'

module SalesEngineWeb
  class Invoice
    attr_reader :id, :customer_id, :merchant_id, :status
    attr_accessor :created_at

    def initialize(params)
      @id = params[:id]
      @customer_id = params[:customer_id]
      @merchant_id = params[:merchant_id]
      @status = params[:status]
      @created_at = params[:created_at]
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
      { :id => id, :customer_id => customer_id, :merchant_id => merchant_id, :status => status, :created_at => created_at }
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
      results.collect {|r| new(r) if r}
    end

    def self.find_all_by_customer_id(customer_id)
      results = invoices.where(:customer_id => customer_id.to_i).to_a
      results.collect {|r| new(r) if r}
    end

    def self.find_all_by_merchant_id(merchant_id)
      results = invoices.where(:merchant_id => merchant_id.to_i).to_a
      results.collect {|r| new(r) if r}
    end

    def self.find_all_by_status(status)
      results = invoices.where(Sequel.ilike(:status, "%#{status}%")).to_a
      results.collect {|r| new(r) if r}
    end

    def self.random
      result = invoices.to_a.sample
      new(result) if result
    end

    def to_json(*args)
      {:id => id, :customer_id => customer_id, :merchant_id => merchant_id, :status => status}.to_json
    end

    def transactions
      Transaction.find_all_by_invoice_id(id)
    end

    def self.all
      results = invoices.to_a
      results.collect{|r| new(r)}
    end

    # def paid_invoices
    #   t = transactions.select{|t| t.successful? }

    # end

    def self.paid_invoices_by_customer_ids
      paid_invoices_per_customer = Hash.new(0)
      paid_invoices.inject(paid_invoices_per_customer) do |sum, pi|
        sum[pi.customer_id] += 1
        sum
      end
      paid_invoices_per_customer
    end

    def paid?
      transactions.any?{|t| t.successful? }
    end

    def total
      if paid?
        invoice_items.inject(0){|sum, ii| sum + ii.subtotal}
      else
        0
      end
    end

    def valid_items_per_invoice
      if self.paid?
        self.item_quantity
      end

      # items_per_invoice = Hash.new(0)
      # paid_invoices.inject(items_per_invoice) do |hash, i|
      #   hash[i.id] +=i.item_quantity
      #   hash
      # end
      # items_per_invoice
    end

    def invoice_items
      InvoiceItem.find_all_by_invoice_id(id)
    end

    def item_quantity
      invoice_items.inject(0){|sum, ii| sum + ii.quantity}
    end

    def item_ids
      invoice_items.collect{|ii| ii.item_id}
    end

    def items
      Item.items.where(:id => item_ids).to_a
    end

    def customer
      Customer.find_by_id(customer_id)
    end

    def merchant
      Merchant.find_by_id(merchant_id)
    end
  end
end