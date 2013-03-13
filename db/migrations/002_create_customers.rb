Sequel.migration do
  change do
    create_table :customers do
      primary_key :id
      String :first_name
      String :last_name
      Datetime :created_at
      Datetime :updated_at 
    end
  end
end