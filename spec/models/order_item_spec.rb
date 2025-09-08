require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:user) { User.create!(name: "Alice", email: "alice@example.com") }
  let(:category) { Category.create!(name: "Electronics") }
  let(:product) { Product.create!(name: "Laptop", price: 1200, sku: "LTP-001", stock_quantity: 5, category: category) }
  let(:order) { Order.create!(user: user, total_price: 1200, status: "pending") }

  it "is valid with order, product, quantity, and price" do
    order_item = OrderItem.new(order: order, product: product, quantity: 1, price: 1200)
    expect(order_item).to be_valid
  end

  it "is invalid without a product" do
    order_item = OrderItem.new(order: order, quantity: 1, price: 1200)
    expect(order_item).not_to be_valid
  end

  it "belongs to an order" do
    assoc = OrderItem.reflect_on_association(:order)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it "belongs to a product" do
    assoc = OrderItem.reflect_on_association(:product)
    expect(assoc.macro).to eq(:belongs_to)
  end
end
