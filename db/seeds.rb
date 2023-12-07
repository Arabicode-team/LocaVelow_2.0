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

User.destroy_all
Bicycle.destroy_all
Rental.destroy_all
Review.destroy_all
Accessory.destroy_all


Faker::Config.locale = 'fr'

bike_models = ["Peugeot", "Lapierre", "Look", "B'Twin", "Time", "Moustache Bikes", "Gitane", "LAPIERRE", "Decathlon", "Sunn"]
cities = ["Paris", "Lourmarin", "Moustiers-Sainte-Marie", "Riquewihr", "Saint-Cirq-Lapopie", "Gordes", "La Roque-Gageac", "Collonges-la-Rouge", "Eguisheim", "Saint-Guilhem-le-Désert", "Ars-en-Ré", "Yvoire", "Castelnou", "Châteauneuf-en-Auxois", "Rochefort-en-Terre", "Sainte-Agnès"]
zip_codes = ["75000", "12320", "24250", "32230", "48170", "56120", "64121", "71460", "82140", "11230", "26240", "32170", "36300", "51500", "71260", "82340"]
streets = ["Avenue de la Tolérance Zéro", "Impasse Pas de Problèmes", "Allée du Déni", "Cul-de-sac de l'inaction", "Route de l'Espoir trompeur", "Esplanade de la Duperie", "Chemin de l'Échec Assuré", "Ruelle de l'Optimisme Démesuré", "Chemin des Illusions Perdues", "Ruelle des Malentendus", "Quai des Blagues Tordues", "Avenue de l'Autodérision", "Promenade des Quotidiens Tragiques", "Chemin des Espoirs Déçus", "Passage de l'Ironie Cruelle", "Route des Rires Solitaires"]
depart = ["Ile-de-France","Lozère", "Creuse", "Haute-Loire", "Ardèche", "Aveyron", "Mayenne", "Nièvre", "Tarn-et-Garonne", "Gers", "Allier"]
accessories = ['Sonnette', 'Antivol', 'Garde-boue', 'Support de téléphone', 'Sac à dos pour vélo', 'Pompe à vélo', 'Casque de vélo', 'Sacoche de selle', 'Antivol de roue', 'Gants de vélo', 'Compteur de vitesse', 'Sac de guidon', 'Réflecteurs', 'Kit de réparation de crevaisons', 'Gilet réfléchissant', 'Support de vélo pour voiture', 'Poignées ergonomiques']
conditions = ["Prêt à dévaler l'Everest", "Comme si le Tour de France l'avait adopté", "Légèrement rouillé mais toujours fiable", "Style rétro-chic des années 1800", "Entraîné à la dure sur la Canebière", "Nouveau", "Comme neuf", "Très bon état", "Bon état", "Usé mais fonctionnel", "En roue libre"]
profiles = ["Amateur de plein air, passionné de cyclisme et de voyages.", "Étudiant passionné de vélos et de randonnées.", "Professionnel du vélo, offrant des vélos de qualité pour une expérience inoubliable.", "Explorateur urbain, prêt à partager mes vélos pour vos aventures en ville.", "Amoureux de la nature, mes vélos sont prêts à vous accompagner dans vos escapades.", "Passionné de vélo depuis toujours, mes deux-roues sont prêts pour vos aventures !", "Cycliste amateur offrant des vélos bien entretenus pour des balades inoubliables.", "Amoureux de la liberté à deux roues, louez mes vélos pour découvrir de nouveaux horizons.", "Voyageur cycliste passionné, partagez l'aventure avec mes vélos fiables et confortables.", "Explorateur des pistes cyclables, mes vélos sont là pour rendre chaque trajet unique."]
coordinates = [{ latitude: 47.084412, longitude: 2.393839 }, { latitude: 48.510858, longitude: 3.308160 }, { latitude: 44.947352, longitude: 1.709030 }, { latitude: 46.836902, longitude: -1.317837 }, { latitude: 48.699892, longitude: -0.656188 }, { latitude: 43.843661, longitude: 1.341457 }, { latitude: 45.062681, longitude: 6.430963 }, { latitude: 48.169578, longitude: 7.389275 }, { latitude: 43.755726, longitude: 5.484195 }, { latitude: 46.682378, longitude: -0.625274 }, { latitude: 47.071055, longitude: 4.423991 }, { latitude: 44.507213, longitude: 3.489435 }, { latitude: 49.453887, longitude: 1.073571 }, { latitude: 43.288769, longitude: -0.367981 }, { latitude: 45.951249, longitude: 1.633849 }, { latitude: 47.861203, longitude: -0.086748 }, { latitude: 43.991852, longitude: 2.464660 }, { latitude: 48.486958, longitude: -2.792172 }, { latitude: 46.301768, longitude: 4.842621 }, { latitude: 42.775135, longitude: -0.292475 }, { latitude: 48.846610, longitude: 2.332825 }, { latitude: 48.860299, longitude: 2.378643 }, { latitude: 48.864716, longitude: 2.361451 }, { latitude: 48.865997, longitude: 2.320582 }, { latitude: 48.860847, longitude: 2.353820 }]

puts "Starting the seed process..."

5.times do
    User.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      admin: false,
      description: profiles.sample,
      email: Faker::Internet.email,
      password: 'password'
    )
  end
  
  10.times do
    coordinates_for_city = coordinates.sample
  
    Bicycle.create!(
      owner: User.all.sample,
      model: bike_models.sample,
      bicycle_type: rand(0..14),
      size: rand(0..5),
      condition: conditions.sample,
      price_per_hour: rand(5..20),
      latitude: coordinates_for_city[:latitude],
      longitude: coordinates_for_city[:longitude],
      address: streets.sample,
      state: depart.sample,
      city: cities.sample,
      country: 'France',
      postal_code: zip_codes.sample,
      description: Faker::Lorem.paragraph
    )
  end  
  
  
10.times do
    Accessory.create!(
      name: accessories.sample,
      bicycle: Bicycle.all.sample
    )
  end
  
  25.times do
    bicycle = Bicycle.all.sample
    renter = User.all.sample
    rental_start = Faker::Time.between(from: DateTime.now, to: DateTime.now + 30)
    rental_end = Faker::Time.between(from: rental_start, to: rental_start + 30.days)
  
    while bicycle.rentals.exists?(['(start_date <= ? AND end_date >= ?) OR (start_date >= ? AND start_date <= ?)', rental_end, rental_start, rental_start, rental_end])
      rental_start = Faker::Time.between(from: DateTime.now, to: DateTime.now + 30)
      rental_end = Faker::Time.between(from: rental_start, to: rental_start + 30.days)
    end
  
    Rental.create!(
      bicycle: bicycle,
      renter: renter,
      start_date: rental_start,
      end_date: rental_end,
      rental_status: rand(0..2),
      total_cost: Faker::Commerce.price(range: 10..100.0, as_string: true)
    )
  end
  
  10.times do
    Review.create!(
      rental: Rental.all.sample,
      reviewed_user: User.all.sample,
      reviewer_user: User.all.sample,
      rating: rand(1..5),
      review_text: Faker::Quotes::Shakespeare.as_you_like_it_quote,
      review_date: Faker::Time.between(from: DateTime.now - 30, to: DateTime.now)
    )
  end
  
  puts "Seeds created successfully!"