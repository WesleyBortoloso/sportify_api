class CreateCourt < ActiveRecord::Migration[7.0]
  def change
    create_table :courts do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.string :description
      t.integer :price, null: false
      t.integer :max_players, null: false
      t.string :status

      t.timestamps
    end
  end
end
