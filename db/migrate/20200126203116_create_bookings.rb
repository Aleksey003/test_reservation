# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :table, null: false, foreign_key: true
      t.datetime :start_date, precision: 6, null: false
      t.datetime :end_date, precision: 6, null: false

      t.timestamps
    end
  end
end
