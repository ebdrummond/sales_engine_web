Sequel.migration do
  change do
    create_table :items do
      primary_key :id
      String :name
      String :description
      Integer :unit_price
      foreign_key :merchant_id
      Datetime :created_at
      Datetime :updated_at 
    end
  end
end