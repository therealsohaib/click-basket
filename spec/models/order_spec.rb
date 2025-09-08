require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { User.create!(name: "Alice", email: "alice@example.com") }

  it "is valid with a user, total_price, and status" do
    order = Order.new(user: user, total_price: 100, status: "pending")
    expect(order).to be_valid
  end

  it "is invalid without a status" do
    order = Order.new(user: user, total_price: 100)
    expect(order).not_to be_valid
  end

  it "belongs to a user" do
    assoc = Order.reflect_on_association(:user)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it "has many order_items" do
    assoc = Order.reflect_on_association(:order_items)
    expect(assoc.macro).to eq(:has_many)
  end
end
