require './lib/sales_engine_web/models/database'

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

    def paid_invoices
      invoices.collect{|i| Invoice.invoices.where(:id => i.id)}
    end

    def revenue(date = :all)
      if date == :all
        calculate_revenue paid_invoices
      else
        calculate_revenue paid_invoices_for_date(date)
      end
    end

    def paid_invoices_for_date(date)
      []
    end

    def calculate_revenue(invoices)
      invoices.inject(0) {|sum,invoice| sum + invoice.revenue }
    end
  end
end