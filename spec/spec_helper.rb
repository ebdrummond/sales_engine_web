Bundler.require
require 'simplecov'
SimpleCov.start
require 'sales_engine_web'

SalesEngineWeb::Database.environment = :test

RSpec.configure do |config|
  config.around(:each) do |example|
    SalesEngineWeb::Database.database.transaction(:rollback => :always) do
      example.run
    end
  end
end
