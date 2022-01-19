class CreateVolumeUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :volume_units do |t|
      t.string :unit

      t.timestamps
    end
  end
end
