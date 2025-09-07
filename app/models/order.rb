class Order < ApplicationRecord
  belongs_to :user

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  scope :pending, -> { where(status: "pending") }
  scope :completed, -> { where(status: "completed") }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :above_total, ->(amount) { where("total_price > ?", amount) }

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w(pending paid completed canceled) }
end
