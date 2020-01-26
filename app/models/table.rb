# frozen_string_literal: true

class Table < ApplicationRecord
  belongs_to :restaurant,
             inverse_of: :tables

  has_many :bookings,
           inverse_of: :table

  validates :name,
            presence: true
end
