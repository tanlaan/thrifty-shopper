class Price < ApplicationRecord
  belongs_to :product
  belongs_to :store

  accepts_nested_attributes_for :store

  def store_attributes=(store_attributes)
    return if store_attributes[:name].blank?

    self.store = Store.find_or_create_by(name: store_attributes[:name])
  end

  def by_product(product_id)
    Price.where('product_id = ?', product_id)
  end
end
