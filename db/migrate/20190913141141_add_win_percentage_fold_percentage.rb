class AddWinPercentageFoldPercentage < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :win_percentage, :float
    add_column :users, :fold_percentage, :float
  end
end
