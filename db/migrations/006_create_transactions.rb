Sequel.migration do
  change do
    create_table :transactions do
      primary_key :id
      foreign_key :invoice_id
      Integer :credit_card_number
      String :credit_card_expiration_date
      String :result
      Datetime :created_at
      Datetime :updated_at 
    end
  end
end