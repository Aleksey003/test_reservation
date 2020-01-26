# frozen_string_literal: true

class User < ApplicationRecord
  has_many :bookings,
           inverse_of: :user

  validates :name,
            presence: true
end
