class Cart < ApplicationRecord
  belongs_to :user


  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
end
