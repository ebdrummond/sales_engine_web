Bundler.require
require './lib/sales_engine_web/models/database'

namespace :db do
  desc "Run migrations for development"
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(SalesEngineWeb::Database.database, "db/migrations")
  end

  desc "Run migrations for test"
  task :test_prepare do
    Sequel.extension :migration
    SalesEngineWeb::Database.environment = :test
    Sequel::Migrator.run(SalesEngineWeb::Database.database, "db/migrations")
  end
end