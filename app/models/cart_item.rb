class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validated :quantity, numericality: { greater_than_or_equal_to: 0 }
end
