class Product < ApplicationRecord
  belongs_to :category

  scope :in_stock, -> {where("stock_quantity > 0")}
  scope :out_of_stock, -> { where(stock_quantity: 0) }
  scope :cheap, -> { where("price < 10") }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :search, ->(query) { where("name ILIKE ?", "%#{query}%") }

  validates :name, presence: true
  validates :sku, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: {only_integer:true, greater_than_or_equal_to: 0 }
end
