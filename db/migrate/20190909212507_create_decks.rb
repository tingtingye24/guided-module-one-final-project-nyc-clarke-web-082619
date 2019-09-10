class CreateDecks < ActiveRecord::Migration[5.0]
  def change
    create_table :decks do |d|
      d.string :outcome
    end
  end
end
