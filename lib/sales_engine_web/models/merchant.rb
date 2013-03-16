require './lib/sales_engine_web/models/database'
require 'time'
require 'date'

module SalesEngineWeb
  class Merchant
    attr_reader :id, :name

    def initialize(params)
      @id = params[:id]
      @name = params[:name]
    end

    def self.create(params)
      Merchant.new(params).save
    end

    def save
      @id = Merchant.add(self)
      self
    end

    def self.add(merchant)
      merchants.insert(merchant.to_hash)
    end

    def to_hash
      { :id => id, :name => name }
    end

    def self.find_by_id(id)
      result = merchants.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_all_by_id(id)
      results = merchants.where(:id => id.to_i).to_a
      results.collect {|r| new(r) if r}
    end

    def self.find_by_name(name)
      result = merchants.limit(1).where(Sequel.ilike(:name, "%#{name}%")).first
      new(result) if result
    end

    def self.find_all_by_name(name)
      results = merchants.where(Sequel.ilike(:name, "%#{name}%")).to_a
      results.collect {|r| new(r)}
    end

    def to_json(*args)
      {:id => id, :name => name}.to_json
    end

    def self.random
      result = merchants.to_a.sample
      new(result) if result
    end

    def self.merchants
      Database.merchants
    end

    def self.all
      results = merchants.to_a
      results.collect{|r| new(r)}
    end

    def items
      Item.find_all_by_merchant_id(id)
    end

    def invoices
      Invoice.find_all_by_merchant_id(id)
    end

    def self.revenue_per_merchant_id
      revenue_per_merchant = Hash.new(0)
      all.inject(revenue_per_merchant) do |hash, m|
        hash[m.id] += m.revenue
        hash
      end
      revenue_per_merchant
    end

    def self.sorted_merchants_by_revenue
      revenue_per_merchant_id.sort {|m1,m2| m2[1]<=>m1[1]}
    end

    def self.sorted_merchant_ids
      ids = sorted_merchants_by_revenue.collect{|m| m[0]}
    end

    def self.revenue(quantity)
      final = sorted_merchant_ids.collect{|i| merchants.where(:id => i).to_a}
      final[0..(quantity.to_i)-1]
    end

    def revenue(date = :all)
      if date == :all
        invoices.inject(0){|sum, i| sum + i.total}
      else
        revenue_for_date(date)
      end
    end

    def revenue_for_date(date)
      date = Date.parse(date).strftime("%Y-%m-%d")
      grand_total = 0
      invoices.each do |invoice|
        invoice.created_at = (invoice.created_at).strftime("%Y-%m-%d")
        if invoice.created_at == date
            grand_total = grand_total + invoice.total
        end
      end
      grand_total
    end

    def paid_invoices
      invoices.select{|i| i.paid? }
    end

    def paid_invoices_by_customer_ids
      paid_invoices_per_customer = Hash.new(0)
      paid_invoices.inject(paid_invoices_per_customer) do |hash, pi|
        hash[pi.customer_id] += 1
        hash
      end
      paid_invoices_per_customer
    end

    def id_of_favorite_customer
      fav_cust = paid_invoices_by_customer_ids.max_by{|k, v| v}
      fav_cust[0]
    end

    def favorite_customer
      Customer.find_by_id(id_of_favorite_customer)
    end

    def pending_invoices
      invoices.reject{|i| i.paid? }
    end

    def pending_invoice_customer_ids
      pending_invoices.collect{|pi| pi.customer_id}
    end

    def customers_with_pending_invoices
      Customer.customers.where(:id => pending_invoice_customer_ids).to_a
    end
  end
end