class Category < ApplicationRecord
  has_many :products

  scope :alphabetical, -> { order(name: :asc) }
  scope :with_products, -> { joins(:products).distinct }

  validates :name, presence: true, uniqueness: true
end
