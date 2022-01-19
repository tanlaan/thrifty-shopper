class CreateUpcs < ActiveRecord::Migration[6.1]
  def change
    create_table :upcs do |t|
      t.string :code

      t.timestamps
    end
  end
end
