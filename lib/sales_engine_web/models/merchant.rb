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

    def items
      Item.find_all_by_merchant_id(id)
    end

    def invoices
      Invoice.find_all_by_merchant_id(id)
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
  end
end