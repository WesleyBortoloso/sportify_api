class CreateBooking < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :court, null: false, foreign_key: true
      t.datetime :starts_on, null: false
      t.datetime :ends_on, null: false
      t.integer :total_value, null: false
      t.string :status, default: 'agendado'
      t.boolean :public, default: true, null: false
      t.string :share_token

      t.timestamps
    end
    add_index :bookings, :share_token, unique: true
  end
end
