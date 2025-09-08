require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:category) { Category.create!(name: "Electronics") }

  it "is valid with valid attributes" do
    product = Product.new(name: "iPhone", price: 999.99, sku: "IPHN-001", stock_quantity: 10, category: category)
    expect(product).to be_valid
  end

  it "is invalid without a name" do
    product = Product.new(price: 100, sku: "TEST-01", category: category)
    expect(product).not_to be_valid
  end
  it "is invalid without a category" do
    product = Product.new(name: "NoCat", price: 100, sku: "NC-01")
    expect(product).not_to be_valid
  end
  it "belongs to a category" do
    assoc = Product.reflect_on_association(:category)
    expect(assoc.macro).to eq(:belongs_to)
  end
end
