require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:user) { User.create!(name: "Alice", email: "alice@example.com") }

  it "is valid with a user" do
    cart = Cart.new(user: user)
    expect(cart).to be_valid
  end

  it "is invalid without a user" do
    cart = Cart.new
    expect(cart).not_to be_valid
  end

  it "belongs to a user" do
    assoc = Cart.reflect_on_association(:user)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it "has many cart_items" do
    assoc = Cart.reflect_on_association(:cart_items)
    expect(assoc.macro).to eq(:has_many)
  end
end
