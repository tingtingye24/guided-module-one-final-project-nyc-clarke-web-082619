class CreateUserdecks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_decks do |u|
      u.integer :user_id
      u.integer :deck_id
    end
  end
end
