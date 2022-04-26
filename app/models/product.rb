class Product < ApplicationRecord
  # Ownership
  has_many :prices
  has_many :product_categories
  has_many :categories, through: :product_categories

  # References
  belongs_to :brand
  belongs_to :upc
  belongs_to :unit

  # Create new brands, categories, UPC when creating new products
  accepts_nested_attributes_for(:brand, :product_categories, :upc )

  def brand_attributes=(brand_attributes)
    if !brand_attributes[:name].blank?
      self.brand = Brand.find_or_create_by(name: brand_attributes[:name])
    end
  end

  def category_attributes=(category_attributes)
    if !category_attributes[:list].blank?
      # Is this a place where we need to look out for sql injection?
      # Create list of category names from comma separated values
      names = category_attributes[:list].split(', ')

      # Create list of actual categories
      new_categories = names.map { |name| Category.find_or_create_by(name: name) }

      self.categories = new_categories

      # self.category = Category.find_or_create_by(name: category_attributes[:name])
    end
  end

  def upc_attributes=(upc_attributes)
    if !upc_attributes[:code].blank?
      self.upc = Upc.find_or_create_by(code: upc_attributes[:code])
    end
  end

  def self.search(query)
    products = []
    upc, name = nil

    # UPC  like
    if only_digits?(query)
      products, upc = code_search(query) unless query.length > 12

    # Title search
    else
      products = Product.where('lower(name) like ?', "%#{query.downcase}%")
      name = query
    end

    [products, upc, name]
  end

  def self.find_by_upc(upc)
    Product.find_by_sql('SELECT products.*
                     FROM products
                     JOIN upcs ON products.upc_id = upcs.id
                     WHERE code = $1
                     LIMIT 1', [upc])
  end

  def self.find_like_upc(fragment)
    Product.find_by_sql('SELECT products.*
                     FROM products
                     JOIN upcs ON products.upc_id = upcs.id
                     WHERE code LIKE $1
                     LIMIT 1', ["%#{fragment}%"])
  end

  # Check string for only digits
  def self.only_digits?(query)
    query.scan(/\D/).empty?
  end

  # Search for code like queries
  def self.code_search(query)
    # We might not need to differentite any longer since we dropped plu
    if query.length < 12
      products = find_like_upc(query)
    else
      products = find_by_upc(query)
    end
    upc = query
    [products, upc]
  end
end
