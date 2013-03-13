module SalesEngineWeb
  class Server < Sinatra::Base
    
    get '/merchants/find' do
      status 200
      if params[:id]
        merchant = Merchant.find_by_id(params[:id])
      else
        merchant = Merchant.find_by_name(params[:name])
      end
      body merchant.to_json
    end

    get '/merchants/find_all' do
      status 200
      if params[:id]
        merchants = Merchant.find_all_by_id(params[:id])
      else
        merchants = Merchant.find_all_by_name(params[:name])
      end
      body merchants.to_json
    end

    get '/merchants/random' do
      status 200
      Merchant.random.to_json
    end

    get '/customers/find' do
      status 200
      if params[:id]
        customer = Customer.find_by_id(params[:id])
      elsif params[:first_name] 
        customer = Customer.find_by_first_name(params[:first_name])
      else
        customer = Customer.find_by_last_name(params[:last_name])
      end
      body customer.to_json
    end

    get '/customers/find_all' do
      status 200
      if params[:id]
        customers = Customer.find_all_by_id(params[:id])
      elsif params[:first_name]
        customers = Customer.find_all_by_first_name(params[:first_name])
      else
        customers = Customer.find_all_by_last_name(params[:last_name])
      end
      body customers.to_json
    end

    get '/customers/random' do
      status 200
      Customer.random.to_json
    end

    get '/invoices/find' do
      status 200
      if params[:id]
        invoice = Invoice.find_by_id(params[:id])
      elsif params[:customer_id]
        invoice = Invoice.find_by_customer_id(params[:customer_id])
      elsif params[:merchant_id]
        invoice = Invoice.find_by_merchant_id(params[:merchant_id])
      else
        invoice = Invoice.find_by_status(params[:status])
      end
      body invoice.to_json
    end

    get '/invoices/find_all' do
      status 200
      if params[:id]
        invoices = Invoice.find_all_by_id(params[:id])
      elsif params[:customer_id]
        invoices = Invoice.find_all_by_customer_id(params[:customer_id])
      elsif params[:merchant_id]
        invoices = Invoice.find_all_by_merchant_id(params[:merchant_id])
      else
        invoices = Invoice.find_all_by_status(params[:status])
      end
      body invoices.to_json
    end

    get '/invoices/random' do
      status 200
      Invoice.random.to_json
    end
  end
end