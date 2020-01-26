# frozen_string_literal: true

class Restaurant < ApplicationRecord
  has_many :tables,
           inverse_of: :restaurant

  validates :name,
            presence: true
end
