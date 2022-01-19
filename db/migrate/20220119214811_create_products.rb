class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :title
      t.string :alias
      t.string :description
      t.float :weight
      t.references :weight_unit, null: true, foreign_key: true
      t.float :volume
      t.references :volume_unit, null: true, foreign_key: true
      t.references :brand, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :upc, null: true, foreign_key: true
      t.references :plu, null: true, foreign_key: true

      t.timestamps
    end
  end
end
