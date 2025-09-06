class User < ApplicationRecord
  has_many :orders
  has_one :cart


  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
