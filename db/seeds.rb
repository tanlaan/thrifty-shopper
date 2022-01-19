# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Start fresh!
Product.destroy_all
Category.destroy_all
Brand.destroy_all
Store.destroy_all
Upc.destroy_all
Plu.destroy_all
WeightUnit.destroy_all
VolumeUnit.destroy_all

# Categories
Category.create(name: 'Fruit')
Category.create(name: 'Vegetable')
Category.create(name: 'Beverage')

# Brand
Brand.create(name: 'Great Value')
Brand.create(name: 'CocaCola')
Brand.create(name: 'La Croix')
Brand.create(name: 'Dole')

# Store
Store.create(name: 'Safeway')
Store.create(name: 'Winco')
Store.create(name: 'Fred Meyer')
Store.create(name: 'Walmart')

# UPC
Upc.create(code: '073360747519') # La Croix Berry Flavor

# PLU
Plu.create(code: '4011')

# Weight_units
WeightUnit.create(unit: 'g')
WeightUnit.create(unit: 'kg')
WeightUnit.create(unit: 'oz')
WeightUnit.create(unit: 'lb')

# Volume_units
VolumeUnit.create(unit: 'ml')
VolumeUnit.create(unit: 'l')
VolumeUnit.create(unit: 'floz')
VolumeUnit.create(unit: 'gal')

# Product
banana = Product.new
banana.title = 'Banana'
banana.alias = 'Banana'
banana.description = 'A standard yellow banana.'
banana.category = Category.find_by(name: 'Fruit')
banana.weight = 0.75
banana.weight_unit = WeightUnit.find_by(unit: 'lb')
banana.plu = Plu.find_by(code: '4011')
banana.brand = Brand.find_by(name: 'Dole')
banana.save
