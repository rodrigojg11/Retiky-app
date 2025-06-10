# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AIRPORTS = {
  "MEX" => "Ciudad de México (MEX)",
  "GDL" => "Guadalajara (GDL)",
  "CUN" => "Cancún (CUN)",
  "JFK" => "Nueva York - JFK (JFK)",
  "LAX" => "Los Ángeles (LAX)",
  "MIA" => "Miami (MIA)",
  "YYZ" => "Toronto (YYZ)",
  "MAD" => "Madrid (MAD)",
  "CDG" => "París - Charles de Gaulle (CDG)",
  "LHR" => "Londres - Heathrow (LHR)",
  "NRT" => "Tokio - Narita (NRT)"
}
  AIRPORTS.each do |fromcode, fromname|
    AIRPORTS.each do |tocode, toname|
      next if fromcode == tocode

      Ticket.create!(
        from: "#{fromcode} - #{fromname}",
        to: "#{tocode} - #{toname}",
        price: rand(100..1500),
        date: Date.today+rand(1..30).days,
        user: User.where(role: "company", active: true).first,
        )
    end
  end
puts "⛔️ Borrando ofertas anteriores..."
# Ticket.destroy_all
puts "✈️ Creando nuevas ofertas..."
# puts "✅ Ofertas creadas: #{Offer.count}"
