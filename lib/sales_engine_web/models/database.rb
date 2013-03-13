module SalesEngineWeb
  class Database

    def self.database
      @database ||= Sequel.sqlite("./db/sales_engine_web_#{ environment }.sqlite3")
    end

    def self.destroy
      if environment == :test
        system "rm './db/sales_engine_web_test.sqlite3'"
      else
        raise "Go do it yourself!"
      end
    end

    def self.merchants
      unless tables.include?(:merchants)
        build_merchants_table
      end

      database[:merchants]
    end

    def self.customers
      unless tables.include?(:customers)
        build_customers_table
      end

      database[:customers]
    end

    def self.invoices
      unless tables.include?(:invoices)
        build_invoices_table
      end

      database[:invoices]
    end

    def self.items
      unless tables.include?(:items)
        build_items_table
      end

      database[:items]
    end

    def self.invoice_items
      unless tables.include?(:invoice_items)
        build_invoice_items_table
      end

      database[:invoice_items]
    end

    def self.transactions
      unless tables.include?(:transactions)
        build_transactions_table
      end

      database[:transactions]
    end

    def self.tables
      @tables ||= []
    end

    def self.build_merchants_table
      database.
      tables << :merchants
    end

    def self.build_customers_table
      database.
      tables << :customers
    end

    def self.build_invoices_table
      database.
      tables << :invoices
    end

    def self.build_items_table
      database.
      tables << :items
    end

    def self.build_invoice_items_table
      database.
      tables << :invoice_items
    end

    def self.build_transactions_table
      database.
      tables << :transactions
    end

    def self.environment=(input)
      @environment = input
    end

    def self.environment
      @environment ||= :development
    end
  end
end