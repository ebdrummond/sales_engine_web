require './lib/sales_engine_web/models/database'

module SalesEngineWeb
  class InvoiceItem
    attr_reader :id, :item_id, :invoice_id, :quantity, :unit_price

    def initialize(params)
      @id = params[:id]
      @item_id = params[:item_id]
      @invoice_id = params[:invoice_id]
      @quantity = params[:quantity]
      @unit_price = params[:unit_price]
    end

    def self.create(params)
      InvoiceItem.new(params).save
    end

    def save
      @id = InvoiceItem.add(self)
      self
    end

    def self.add(invoice_item)
      invoice_items.insert(invoice_item.to_hash)
    end

    def to_hash
      { :id => id, :item_id => item_id, :invoice_id => invoice_id, :quantity => quantity, :unit_price => unit_price }
    end

    def self.find_by_id(id)
      result = invoice_items.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_all_by_id(id)
      results = invoice_items.where(:id => id.to_i).to_a
      results.collect {|r| new(r) if r}
    end

    def self.find_by_item_id(item_id)
      result = invoice_items.where(:item_id => item_id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_all_by_item_id(item_id)
      results = invoice_items.where(:item_id => item_id.to_i).to_a
      results.collect {|r| new(r) if r}
    end

    def self.find_by_invoice_id(invoice_id)
      result = invoice_items.where(:invoice_id => invoice_id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_all_by_invoice_id(invoice_id)
      results = invoice_items.where(:invoice_id => invoice_id.to_i).to_a
      results.collect {|r| new(r) if r}
    end

    def self.find_by_quantity(quantity)
      result = invoice_items.where(:quantity => quantity.to_i).limit(1).first
      new(result) if result
    end

    def self.find_all_by_quantity(quantity)
      results = invoice_items.where(:quantity => quantity.to_i).to_a
      results.collect {|r| new(r) if r}
    end

    def self.find_by_unit_price(unit_price)
      result = invoice_items.where(:unit_price => unit_price.to_i).limit(1).first
      new(result) if result
    end

    def self.find_all_by_unit_price(unit_price)
      results = invoice_items.where(:unit_price => unit_price.to_i).to_a
      results.collect {|r| new(r) if r}
    end

    def to_json(*args)
      {:id => id, :item_id => item_id, :invoice_id => invoice_id, :quantity => quantity, :unit_price => unit_price}.to_json
    end

    def self.random
      result = invoice_items.to_a.sample
      new(result) if result
    end

    def self.invoice_items
      Database.invoice_items
    end

    def invoice
      Invoice.find_by_id(invoice_id)
    end

    def item
      Item.find_by_id(item_id)
    end

    def subtotal
      quantity * unit_price
    end
  end
end