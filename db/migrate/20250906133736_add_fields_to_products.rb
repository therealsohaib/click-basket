class AddFieldsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :description, :text
    add_column :products, :stock_quantity, :integer
    add_reference :products, :category, null: false, foreign_key: true
  end
end
