module SalesEngineWeb
  class MerchantsController
    def self.find(args)
      # clean the args to remove the args that should not ever be considered
      args = clean_args(args)
      method_name = "find_by_#{args.keys.first}"
      merchant = Merchant.send(method_name, args.values.first)
      Response.new(:body => merchant.to_json, :success => !merchant.nil?)
    end

    def self.clean_args(args)
      # only allow :id, :name, and whatever else you should have
      args
    end

    def self.find_all(args)
      method_name = "find_all_by_#{args.keys.first}"
      merchants = Merchant.send(method_name, args.values.first)
      Response.new(:body => merchants.to_json)
    end

    def self.random
      merchant = Merchant.random
      Response.new(:body => merchant.to_json)
    end
  end
end