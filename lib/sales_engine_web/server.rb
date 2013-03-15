module SalesEngineWeb
  class Server < Sinatra::Base
    
    def respond_with(response)
      #status response.status
      body response.body
    end

    get '/merchants/find' do
      # merchant = Merchant.find_by_id(params[:id]) || Merchant.find_by_name(params[:name])
      respond_with MerchantsController.find(params)

      # if params[:id]
      #   merchant = Merchant.find_by_id(params[:id])
      # else
      #   merchant = Merchant.find_by_name(params[:name])
      # end

      # if merchant
      #   status 200
      #   body merchant.to_json
      # else
      #   status 404
      #   halt
      # end
    end

    get '/merchants/find_all' do
      respond_with MerchantsController.find_all(params)
      
      # status 200
      # if params[:id]
      #   merchants = Merchant.find_all_by_id(params[:id])
      # else
      #   merchants = Merchant.find_all_by_name(params[:name])
      # end
      # body merchants.to_json
    end

    get '/merchants/random' do
      respond_with MerchantsController.random
      # status 200
      # Merchant.random.to_json
    end

    get '/merchants/:id/items' do
      id = params[:id]
      merchant = Merchant.find_by_id(id)
      status 200
      body merchant.items.to_json
    end

    get '/merchants/:id/invoices' do
      id = params[:id]
      merchant = Merchant.find_by_id(id)
      status 200
      body merchant.invoices.to_json
    end

    get '/merchants/:id/revenue' do
      id = params[:id]
      merchant = Merchant.find_by_id(id)
      status 200
      body merchant.revenue.to_s
    end

    get '/merchants/:id/revenue/:date' do
      id = params[:id]
      date = params[:date]
      merchant = Merchant.find_by_id(id)
      status 200
      body merchant.revenue_for_date(date).to_s
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

    get '/customers/:id/invoices' do
      id = params[:id]
      customer = Customer.find_by_id(id)
      status 200
      body customer.invoices.to_json
    end

    get '/customers/:id/transactions' do
      id = params[:id]
      customer = Customer.find_by_id(id)
      status 200
      body customer.transactions.to_json
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

    get '/invoices/:id/transactions' do
      id = params[:id]
      invoice = Invoice.find_by_id(id)
      status 200
      body invoice.transactions.to_json
    end

    get '/invoices/:id/invoice_items' do
      id = params[:id]
      invoice = Invoice.find_by_id(id)
      status 200
      body invoice.invoice_items.to_json
    end

    get '/invoices/:id/items' do
      id = params[:id]
      invoice = Invoice.find_by_id(id)
      status 200
      body invoice.items.to_json
    end

    get '/invoices/:id/customer' do
      id = params[:id]
      invoice = Invoice.find_by_id(id)
      status 200
      body invoice.customer.to_json
    end

    get '/invoices/:id/merchant' do
      id = params[:id]
      invoice = Invoice.find_by_id(id)
      body invoice.merchant.to_json
    end

    get '/items/find' do
      status 200
      if params[:id]
        item = Item.find_by_id(params[:id])
      elsif params[:name]
        item = Item.find_by_name(params[:name])
      elsif params[:description]
        item = Item.find_by_description(params[:description])
      elsif params[:unit_price]
        item = Item.find_by_unit_price(params[:unit_price])
      else
        item = Item.find_by_merchant_id(params[:merchant_id])
      end
      body item.to_json
    end

    get '/items/find_all' do
      status 200
      if params[:id]
        items = Item.find_all_by_id(params[:id])
      elsif params[:name]
        items = Item.find_all_by_name(params[:name])
      elsif params[:description]
        items = Item.find_all_by_description(params[:description])
      elsif params[:unit_price]
        items = Item.find_all_by_unit_price(params[:unit_price])
      else
        items = Item.find_all_by_merchant_id(params[:merchant_id])
      end
      body items.to_json
    end

    get '/items/random' do
      status 200
      Item.random.to_json
    end

    get '/items/:id/invoice_items' do
      id = params[:id]
      item = Item.find_by_id(id)
      status 200
      body item.invoice_items.to_json
    end

    get '/items/:id/merchant' do
      id = params[:id]
      item = Item.find_by_id(id)
      body item.merchant.to_json
    end

    get '/invoice_items/find' do
      status 200
      if params[:id]
        invoice_item = InvoiceItem.find_by_id(params[:id])
      elsif params[:item_id]
        invoice_item = InvoiceItem.find_by_item_id(params[:item_id])
      elsif params[:invoice_id]
        invoice_item = InvoiceItem.find_by_invoice_id(params[:invoice_id])
      elsif params[:unit_price]
        invoice_item = InvoiceItem.find_by_unit_price(params[:unit_price])
      else
        invoice_item = InvoiceItem.find_by_quantity(params[:quantity])
      end
      body invoice_item.to_json
    end

    get '/invoice_items/find_all' do
      status 200
      if params[:id]
        invoice_items = InvoiceItem.find_all_by_id(params[:id])
      elsif params[:item_id]
        invoice_items = InvoiceItem.find_all_by_item_id(params[:item_id])
      elsif params[:invoice_id]
        invoice_items = InvoiceItem.find_all_by_invoice_id(params[:invoice_id])
      elsif params[:unit_price]
        invoice_items = InvoiceItem.find_all_by_unit_price(params[:unit_price])
      else
        invoice_items = InvoiceItem.find_all_by_quantity(params[:quantity])
      end
      body invoice_items.to_json
    end

    get '/invoice_items/random' do
      status 200
      InvoiceItem.random.to_json
    end

    get '/invoice_items/:id/invoice' do
      id = params[:id]
      invoice_item = InvoiceItem.find_by_id(id)
      status 200
      body invoice_item.invoice.to_json
    end

    get '/invoice_items/:id/item' do
      id = params[:id]
      invoice_item = InvoiceItem.find_by_id(id)
      status 200
      body invoice_item.item.to_json
    end

    get '/transactions/find' do
      status 200
      if params[:id]
        transaction = Transaction.find_by_id(params[:id])
      elsif params[:invoice_id]
        transaction = Transaction.find_by_invoice_id(params[:invoice_id])
      elsif params[:credit_card_number]
        transaction = Transaction.find_by_credit_card_number(params[:credit_card_number])
      else
        transaction = Transaction.find_by_result(params[:result])
      end
      body transaction.to_json
    end

    get '/transactions/find_all' do
      status 200
      if params[:id]
        transactions = Transaction.find_all_by_id(params[:id])
      elsif params[:invoice_id]
        transactions = Transaction.find_all_by_invoice_id(params[:invoice_id])
      elsif params[:credit_card_number]
        transactions = Transaction.find_all_by_credit_card_number(params[:credit_card_number])
      else
        transactions = Transaction.find_all_by_result(params[:result])
      end
      body transactions.to_json
    end

    get '/transactions/random' do
      status 200
      Transaction.random.to_json
    end

    get '/transactions/:id/invoice' do
      id = params[:id]
      transaction = Transaction.find_by_id(id)
      status 200
      body transaction.invoice.to_json
    end
  end
end