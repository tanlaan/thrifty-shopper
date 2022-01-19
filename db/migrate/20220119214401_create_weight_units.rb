class CreateWeightUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :weight_units do |t|
      t.string :unit

      t.timestamps
    end
  end
end
