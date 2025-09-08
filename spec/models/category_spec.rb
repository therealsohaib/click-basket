require 'rails_helper'

RSpec.describe Category, type: :model do
  it "is valid with a name" do
    category = Category.new(name: "Electronics")
    expect(category).to be_valid
  end

  it "is invalid without a name" do
    category = Category.new
    expect(category).not_to be_valid
  end

  it "has many products" do
    assoc = Category.reflect_on_association(:products)
    expect(assoc.macro).to eq(:has_many)
  end
end
