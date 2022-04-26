json.extract! product, :id, :name, :description, :magnitude, :unit, :brand_id, :category_id, :upc_id, :created_at, :updated_at
json.url product_url(product, format: :json)
