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

# User creation
5.times do
    User.create!(
      email: Faker::Internet.email,
      password: 'password',
      password_confirmation: 'password'
    )
  end
  
  users = User.all
  
  # Bicycle creation
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
  
  # Création d'accessoires
  10.times do
    Accessory.create!(
      name: Faker::Commerce.product_name,
      bicycle: bicycles.sample
    )
  end
  

  

# Rental creation (with reviews)
start_date = Date.today

bicycles.each do |bicycle|
  rand(0..5).times do
    renter = users.sample

    # Generate a random end date between 1 and 5 days after the start date
    start_date += rand(1..5)
    end_date = start_date + rand(1..5)

    rental = Rental.create!(
      bicycle: bicycle,
      renter: renter,
      start_date: start_date,
      end_date: end_date,
      rental_status: Rental.rental_statuses.keys.sample
    )

    # Reset the start date for the next rental
    start_date = end_date

    # Create a review for the rental
    Review.create!(
      rental: rental,
      reviewed_user: bicycle.owner, # The owner of the bicycle as the reviewed_user
      reviewer_user: renter,        # The renter of the bicycle as the reviewer_user
      rating: rand(1..5),
      review_text: Faker::Lorem.sentence(word_count: 15),
    )
  end
end
  
  