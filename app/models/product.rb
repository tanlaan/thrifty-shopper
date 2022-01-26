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
  accepts_nested_attributes_for(:brand, :category, :upc, :plu)

  def brand_attributes=(brand_attributes)
    if !brand_attributes[:name].blank?
      self.brand = Brand.find_or_create_by(name: brand_attributes[:name])
    end
  end

  def category_attributes=(category_attributes)
    if !category_attributes[:name].blank?
      self.category = Category.find_or_create_by(name: category_attributes[:name])
    end
  end

  def upc_attributes=(upc_attributes)
    if !upc_attributes[:code].blank?
      self.upc = Upc.find_or_create_by(code: upc_attributes[:code])
    end
  end

  def plu_attributes=(plu_attributes)
    if !plu_attributes[:code].blank?
      self.plu = Plu.find_or_create_by(code: plu_attributes[:code])
    end
  end

  def self.search(query)
    products = []
    upc, plu, title = nil

    # UPC or PLU like
    if only_digits?(query)
      products, upc, plu = code_search(query) unless query.length > 12

    # Title search
    else
      products = Product.where('lower(title) like ?', "%#{query.downcase}%")
      title = query
    end

    [products, upc, plu, title]
  end

  def self.find_by_plu(plu)
    Product.find_by_sql('SELECT products.*
                     FROM products
                     JOIN plus ON products.plu_id = plus.id
                     WHERE code = $1
                     LIMIT 1', [plu])
  end

  def self.find_by_upc(upc)
    Product.find_by_sql('SELECT products.*
                     FROM products
                     JOIN upcs ON products.upc_id = upcs.id
                     WHERE code = $1
                     LIMIT 1', [upc])
  end

  def self.find_like_plu(fragment)
    Product.find_by_sql('SELECT products.*
                     FROM products
                     JOIN plus ON products.plu_id = plus.id
                     WHERE code LIKE $1
                     LIMIT 1', ["%#{fragment}%"])
  end

  def self.find_like_upc(fragment)
    Product.find_by_sql('SELECT products.*
                     FROM products
                     JOIN upcs ON products.upc_id = upcs.id
                     WHERE code LIKE $1
                     LIMIT 1', ["%#{fragment}%"])
  end

  def self.find_by_code_fragment(fragment)
    case fragment.length
    when 6..11
      products = find_like_upc(fragment)
    when 1..3
      products = find_like_plu(fragment)
    end
    products
  end

  # Check string for only digits
  def self.only_digits?(query)
    query.scan(/\D/).empty?
  end

  # Search for code like queries
  def self.code_search(query)
    case query.length
    when 12 # UPC length
      products = find_by_upc(query)
      upc = query
    when 4, 5 # PLU length
      products = find_by_plu(query)
      plu = query
    else # is fragment
      products = find_by_code_fragment(query)
    end
    [products, upc, plu]
  end
end
