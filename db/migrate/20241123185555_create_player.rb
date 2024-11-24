class CreatePlayer < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :nickname
      t.string :role

      t.timestamps
    end
  end
end
