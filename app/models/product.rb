class Product < ApplicationRecord
  has_many :prices
  belongs_to :weight_unit, optional: true
  belongs_to :volume_unit, optional: true
  belongs_to :brand
  belongs_to :category
  belongs_to :upc, optional: true
  belongs_to :plu, optional: true
end
