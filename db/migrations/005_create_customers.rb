Sequel.migration do
  up do
    create_table(:customers) do
      primary_key :id, :type => :varchar, :auto_increment => false, :unique => true
      String :first_name, :null => false
      String :last_name, :null => false
      String :email, :null => false, :unique => true
      String :password, :null => false
      String :country, :null => false

      DateTime :created_at
      DateTime :updated_at
      DateTime :last_login_at
      # foreign_key :shopping_basket_id, :shopping_baskets, :null => false
    end
  end

  down do
    drop_table(:customers)
  end
end