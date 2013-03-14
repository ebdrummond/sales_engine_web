require './lib/sales_engine_web/models/database'

module SalesEngineWeb

  # module HasId

  #   def self.table
  #     puts "Class Name: #{name} Customer => customers"
  #     table_name = "#{name.downcase}s"
  #     Database.send(table_name)
  #   end

  #   def self.find_by_id(id)
  #     result = table.where(:id => id.to_i).limit(1).first
  #     new(result) if result
  #   end
    
  #   def self.find_all_by_id(id)
  #     results = table.where(:id => id.to_i).to_a
  #     results.collect {|r| new(r) if r}
  #   end

  # end



  class Customer
    attr_reader :id, :first_name, :last_name

    # extend HasId

    # def self.attribute(name)

    #   define_singleton_method "find_by_#{name}" do |search_by_id|
    #     result = table.where(:id => id.to_i).limit(1).first
    #     new(result) if result
    #   end
    # end

    # attribute(:id)

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

    def to_json
      {:id => id, :first_name => first_name, :last_name => last_name}.to_json
    end

    def invoices
      Invoice.find_all_by_customer_id(id)
    end

    def invoice_ids
      invoices.collect{|i| i.id}
    end

    def transactions
      Transaction.transactions.where(:invoice_id => invoice_ids)
    end
  end
end

