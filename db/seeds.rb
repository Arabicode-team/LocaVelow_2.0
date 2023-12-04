# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "faker"

# db/seeds.rb

# Предполагается, что у вас уже есть некоторые пользователи
5.times do
    User.create!(
      email: Faker::Internet.email,
      password: 'password',
      password_confirmation: 'password'
    )
  end
  
  users = User.all
  
  # Создаем велосипеды
  10.times do
    Bicycle.create!(
      owner: users.sample,
      model: Faker::Vehicle.make_and_model,
      bicycle_type: Bicycle.bicycle_types.keys.sample,
      size: Bicycle.sizes.keys.sample,
      condition: ['new', 'used', 'good', 'excellent'].sample,
      price_per_hour: rand(5..20),
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude,
      address: Faker::Address.full_address
    )
  end
  
  bicycles = Bicycle.all
  
  # Создаем аксессуары
  10.times do
    Accessory.create!(
      name: Faker::Commerce.product_name,
      bicycle: bicycles.sample
    )
  end
  
  # Создаем аренды и отзывы
  # ... код для создания пользователей и велосипедов ...

# Создаем аренды и отзывы
bicycles.each do |bicycle|
    rand(0..5).times do
      renter = users.sample
      rental = Rental.create!(
        bicycle: bicycle,
        renter: renter,
        start_date: Faker::Date.backward(days: 14),
        end_date: Faker::Date.backward(days: 7),
        rental_status: Rental.rental_statuses.keys.sample
      )
  
      # Создание отзыва от арендатора
      Review.create!(
        rental: rental,
        reviewed_user: bicycle.owner, # Владелец велосипеда как reviewed_user
        reviewer_user: renter,        # Арендатор как reviewer_user
        rating: rand(1..5),
        review_text: Faker::Lorem.sentence(word_count: 15),
        review_date: Faker::Date.backward(days: 3)
      )
  
      # Создание отзыва от владельца
      Review.create!(
        rental: rental,
        reviewed_user: renter,        # Арендатор как reviewed_user
        reviewer_user: bicycle.owner, # Владелец велосипеда как reviewer_user
        rating: rand(1..5),
        review_text: Faker::Lorem.sentence(word_count: 15),
        review_date: Faker::Date.backward(days: 2)
      )
    end
  end
  
  puts "Seed data created successfully!"
  
  