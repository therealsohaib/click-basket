require 'faker'

# Reset Faker uniqueness
Faker::UniqueGenerator.clear

puts "Cleaning up old records..."
CartItem.destroy_all
Cart.destroy_all
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all

puts "Creating Users..."
users = 50.times.map do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email
  )
end

puts "Creating Categories..."
categories = [
  "Electronics", "Clothing", "Books", "Sports", "Home", "Beauty"
].map do |cat|
  Category.find_or_create_by!(name: cat)
end

puts "Creating Products..."
products = 50.times.map do
  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    price: Faker::Commerce.price(range: 10.0..500.0),
    sku: Faker::Alphanumeric.alphanumeric(number: 8).upcase,
    stock_quantity: rand(1..100),
    category: categories.sample
  )
end

puts "Creating Carts and CartItems..."
users.each do |user|
  cart = Cart.create!(
    user: user,
    total_price: 0
  )

  rand(1..5).times do
    product = products.sample
    quantity = rand(1..3)

    CartItem.create!(
      cart: cart,
      product: product,
      quantity: quantity
    )

    cart.total_price ||= 0
    cart.total_price += product.price * quantity
    cart.save!
  end
end

puts "Creating Orders with OrderItems..."
users.sample(30).each do |user|
  order = Order.create!(
    user: user,
    total_price: 0,
    status: %w[pending paid completed canceled].sample
  )

  rand(1..4).times do
    product = products.sample
    quantity = rand(1..2)

    OrderItem.create!(
      order: order,
      product: product,
      quantity: quantity,
      price: product.price
    )

    order.total_price ||= 0
    order.total_price += product.price * quantity
    order.save!
  end
end

puts "Seeding done!"
puts "Summary:"
puts " Users: #{User.count}"
puts " Categories: #{Category.count}"
puts " Products: #{Product.count}"
puts " Carts: #{Cart.count}"
puts " CartItems: #{CartItem.count}"
puts " Orders: #{Order.count}"
puts " OrderItems: #{OrderItem.count}"
