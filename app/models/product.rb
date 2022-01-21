class Product < ApplicationRecord
  # Ownership
  has_many :prices

  # References
  belongs_to :weight_unit, optional: true
  belongs_to :volume_unit, optional: true
  belongs_to :brand
  belongs_to :category
  belongs_to :upc, optional: true
  belongs_to :plu, optional: true

  # Create new brands, categories, UPC, PLU when creating new products
  # accepts_nested_attributes_for(:brand, :category, :upc, :plu)
end
