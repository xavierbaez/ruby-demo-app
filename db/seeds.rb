# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Metric.destroy_all

[ "Apple TV", "App Store", "Apple Music" ].each do |service|
  10.times do |i|
    Metric.create!(
      service_name: service,
      metric_name: "quality_score",
      value: rand(80..100),
      recorded_on: Date.today - i.days
    )
  end
end
