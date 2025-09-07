class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  scope :empty, -> { joins(:cart_items).where(cart_items: { id: nil }) }
  scope :non_empty, -> { joins(:cart_items).distinct }

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
