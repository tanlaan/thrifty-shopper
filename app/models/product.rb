class Product < ApplicationRecord
  belongs_to :weight_unit
  belongs_to :volume_unit
  belongs_to :brand
  belongs_to :category
  belongs_to :upc
  belongs_to :plu
end
