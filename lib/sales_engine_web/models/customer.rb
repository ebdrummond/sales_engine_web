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
      results.each {|r| new(r) if r}
    end

    def self.find_all_by_first_name(first_name)
      results = customers.where(Sequel.ilike(:first_name, "%#{first_name}%")).to_a
      results.each {|r| new(r) if r}
    end

    def self.find_all_by_last_name(last_name)
      results = customers.where(Sequel.ilike(:last_name, "%#{last_name}%")).to_a
      results.each {|r| new(r) if r}
    end

    def self.random
      result = customers.to_a.sample
      new(result) if result
    end

    def to_json
      {:id => id, :first_name => first_name, :last_name => last_name}.to_json
    end
  end
end

