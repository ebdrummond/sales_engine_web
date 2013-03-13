Bundler.require
require 'simplecov'
SimpleCov.start
require './lib/sales_engine_web/server'
require './lib/sales_engine_web/models/merchant'
require './lib/sales_engine_web/models/database'
require './lib/sales_engine_web/models/customer'
require './lib/sales_engine_web/models/invoice'
require './lib/sales_engine_web/models/items'

SalesEngineWeb::Database.environment = :test

RSpec.configure do |config|
  config.around(:each) do |example|
    SalesEngineWeb::Database.database.transaction(:rollback => :always) do
      example.run
    end
  end
end
