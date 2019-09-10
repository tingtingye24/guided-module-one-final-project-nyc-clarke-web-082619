class CreateWallets < ActiveRecord::Migration[5.0]
  def change
    create_table :wallets do |w|
      w.integer :money
      w.integer :user_id
    end
  end
end
