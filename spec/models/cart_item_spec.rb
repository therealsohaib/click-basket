require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:user) { User.create!(name: "Alice", email: "alice@example.com") }
  let(:cart) { Cart.create!(user: user) }
  let(:category) { Category.create!(name: "Electronics") }
  let(:product) { Product.create!(name: "Laptop", price: 1200, sku: "LTP-001", stock_quantity: 5, category: category) }

  it "is valid with cart, product, and quantity" do
    cart_item = CartItem.new(cart: cart, product: product, quantity: 2)
    expect(cart_item).to be_valid
  end

  it "is invalid without a product" do
    cart_item = CartItem.new(cart: cart, quantity: 2)
    expect(cart_item).not_to be_valid
  end

  it "belongs to a cart" do
    assoc = CartItem.reflect_on_association(:cart)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it "belongs to a product" do
    assoc = CartItem.reflect_on_association(:product)
    expect(assoc.macro).to eq(:belongs_to)
  end
end
