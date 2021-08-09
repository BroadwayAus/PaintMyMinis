json.extract! listing, :id, :name, :description, :price, :available, :user_id, :category, :created_at, :updated_at
json.url listing_url(listing, format: :json)
