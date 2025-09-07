class Cart < ApplicationRecord
  belongs_to :user

  scope :for_product, ->(product_id) { where(product_id: product_id) }
  scope :for_cart, ->(cart_id) { where(cart_id: cart_id) }

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
end
