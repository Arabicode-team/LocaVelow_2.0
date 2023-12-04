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

# Supprimer toutes les données existantes
User.destroy_all
Bicycle.destroy_all
Rental.destroy_all
Review.destroy_all

# Créer un utilisateur spécifique sans locations en cours
user_without_rentals = User.create!(
  email: 'user_without_rentals@example.com',
  password: 'password',
  # Ajoutez ici d'autres attributs si nécessaire
)

# Créer des utilisateurs normaux avec des locations en cours
users = []
5.times do
  user = User.create!(
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    # Ajoutez ici d'autres attributs si nécessaire
  )
  users << user
end

# Créer des vélos
bicycles = []
10.times do
  bicycle = Bicycle.create!(
    owner: users.sample,
    # Ajoutez ici les attributs nécessaires pour créer un Bicycle
  )
  bicycles << bicycle
end

start_date = Date.today

bicycles.each do |bicycle|
  # Assurez-vous que le vélo n'appartient pas à l'utilisateur sans locations
  next if bicycle.owner == user_without_rentals

  rand(0..5).times do
    renter = users.sample

    Rental.create!(
      renter: renter,
      bicycle: bicycle,
      start_date: start_date,
      end_date: nil, # end_date is nil to indicate the rental is in progress
      # Add other necessary attributes for Rental
    )
  end
end