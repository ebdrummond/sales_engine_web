require './lib/sales_engine_web/models/database'

module SalesEngineWeb
  class Item
    attr_reader :id, :name, :description, :unit_price, :merchant_id

    def initialize(params)
      @id = params[:id]
      @name = params[:name]
      @description = params[:description]
      @unit_price = params[:unit_price]
      @merchant_id = params[:merchant_id]
    end

    def self.create(params)
      Item.new(params).save
    end

    def save
      @id = Item.add(self)
      self
    end

    def self.add(item)
      items.insert(item.to_hash)
    end

    def to_hash
      { :id => id, :name => name, :description => description, :unit_price => unit_price, :merchant_id => merchant_id }
    end

    def self.items
      Database.items
    end

    def self.find_by_id(id)
      result = items.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_by_name(name)
      result = items.limit(1).where(Sequel.ilike(:name, "%#{name}%")).first
      new(result) if result
    end

    def self.find_by_description(description)
      result = items.limit(1).where(Sequel.ilike(:description, "%#{description}%")).first
      new(result) if result
    end

    def self.find_by_unit_price(unit_price)
      result = items.where(:unit_price => unit_price.to_i).limit(1).first
      new(result) if result
    end

    def self.find_by_merchant_id(merchant_id)
      result = items.where(:merchant_id => merchant_id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_all_by_id(id)
      results = items.where(:id => id.to_i).to_a
      results.each {|r| new(r) if r}
    end

    def self.find_all_by_name(name)
      results = items.where(Sequel.ilike(:name, "%#{name}%")).to_a
      results.each {|r| new(r) if r}
    end

    def self.find_all_by_description(description)
      results = items.where(Sequel.ilike(:description, "%#{description}%")).to_a
      results.each {|r| new(r) if r}
    end

    def self.find_all_by_unit_price(unit_price)
      results = items.where(:unit_price => unit_price.to_i).to_a
      results.each {|r| new(r) if r}
    end

    def self.find_all_by_merchant_id(merchant_id)
      results = items.where(:merchant_id => merchant_id.to_i).to_a
      results.each {|r| new(r) if r}
    end

    def self.random
      result = items.to_a.sample
      new(result) if result
    end

    def to_json
      {:id => id, :name => name, :description => description, :unit_price => unit_price, :merchant_id => merchant_id}.to_json
    end

    def invoice_items
      InvoiceItem.find_all_by_item_id(id)
    end
  end
end