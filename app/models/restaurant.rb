# frozen_string_literal: true

class Restaurant < ApplicationRecord
  validates :name,
            presence: true

  has_many :tables,
           inverse_of: :restaurant
end
