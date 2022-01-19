class CreatePlus < ActiveRecord::Migration[6.1]
  def change
    create_table :plus do |t|
      t.string :code

      t.timestamps
    end
  end
end
