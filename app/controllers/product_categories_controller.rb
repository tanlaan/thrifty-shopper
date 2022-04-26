class Product < ApplicationRecord
  accepts_nested_attributes_for(:categories)
end
