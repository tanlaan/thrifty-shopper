class SimplifyProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :units do |t|
      t.string :unit
      t.timestamps
    end


    change_table :products do |t|
      t.rename :title, :name
      
      t.remove(:alias, type: :string)
      t.remove(:weight, type: :float)
      t.remove(:volume, type: :float)

      t.remove_references(:plu)
      t.remove_references(:volume_unit)
      t.remove_references(:weight_unit)
      t.remove_references(:category)

      t.float :magnitude, null: false
      
      t.references :unit, null: false, foreign_key: true
    end

    change_column_null(:products, :upc_id, false)
    change_column_null(:products, :name, false)

    create_table :product_categories do |t|
      t.references :product, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end

    drop_table :plus do |t|
      t.string :code, null: false
      t.timestamps null: false
    end

    drop_table :weight_units do |t|
      t.string :unit, null: false
      t.timestamps null: false
    end

    drop_table :volume_units do |t|
      t.string :unit, null: false
      t.timestamps null: false
    end
  end
end
