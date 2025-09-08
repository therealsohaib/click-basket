require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a name and email" do
    user = User.new(name: "Alice", email: "alice@example.com")
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = User.new(email: "bob@example.com")
    expect(user).not_to be_valid
  end

  it "is invalid without an email" do
    user = User.new(name: "Bob")
    expect(user).not_to be_valid
  end

  it "has many orders" do
    assoc = User.reflect_on_association(:orders)
    expect(assoc.macro).to eq(:has_many)
  end

  it "has one cart" do
    assoc = User.reflect_on_association(:cart)
    expect(assoc.macro).to eq(:has_one)
  end
end