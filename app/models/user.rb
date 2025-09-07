class User < ApplicationRecord
  has_many :orders
  has_one :cart

  scope :with_orders, -> { joins(:orders).distinct }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_email, ->(email) { where(email: email) }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
