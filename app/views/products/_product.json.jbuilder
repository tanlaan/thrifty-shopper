json.extract! product, :id, :title, :alias, :description, :weight, :weight_unit_id, :volume, :volume_unit_id, :brand_id, :category_id, :upc_id, :plu_id, :created_at, :updated_at
json.url product_url(product, format: :json)
