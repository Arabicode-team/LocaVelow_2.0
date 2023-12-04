json.extract! bicycle, :id, :owner_id, :model, :bicycle_type, :size, :condition, :price_per_hour, :latitude, :longitude, :address, :created_at, :updated_at
json.url bicycle_url(bicycle, format: :json)
