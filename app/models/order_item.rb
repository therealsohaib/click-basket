class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  scope :by_product, ->(product_id) { where(product_id: product_id) }
  scope :large_quantity, -> { where("quantity >= 5") }

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
