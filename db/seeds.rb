# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "⛔️ Borrando ofertas anteriores..."
Offer.destroy_all

puts "✈️ Creando nuevas ofertas..."

Offer.create!(
  title: "Vuelo CDMX - Madrid",
  description: "Vuelo directo ida y vuelta desde Ciudad de México a Madrid.",
  price: 850.00,
  origin: "Ciudad de México",
  destination: "Madrid",
  departure_date: Date.new(2025, 7, 10)
)

Offer.create!(
  title: "Vuelo Lima - Buenos Aires",
  description: "Vuelo económico con escala en Santiago.",
  price: 430.50,
  origin: "Lima",
  destination: "Buenos Aires",
  departure_date: Date.new(2025, 7, 15)
)

Offer.create!(
  title: "Vuelo Bogotá - Cancún",
  description: "Viaje todo incluido para disfrutar del Caribe.",
  price: 590.75,
  origin: "Bogotá",
  destination: "Cancún",
  departure_date: Date.new(2025, 8, 5)
)

puts "✅ Ofertas creadas: #{Offer.count}"
