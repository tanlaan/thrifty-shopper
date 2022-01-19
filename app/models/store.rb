class Store < ApplicationRecord
  has_many :prices
  has_many :products, through: :prices
end
