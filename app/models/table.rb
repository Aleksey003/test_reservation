# frozen_string_literal: true

class Table < ApplicationRecord
  belongs_to :restaurant,
             inverse_of: :tables

  validates :name,
            presence: true
end
