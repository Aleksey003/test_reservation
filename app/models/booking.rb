# frozen_string_literal: true

class Booking < ApplicationRecord
  STEP = 30

  belongs_to :user,
             inverse_of: :bookings

  belongs_to :table,
             inverse_of: :bookings

  validates :start_date, :end_date,
            presence: true

  validate :end_date_greater_than_start_date

  validate :step_between_start_and_end_date

  private

  def end_date_greater_than_start_date
    return if start_date.nil? || end_date.nil?

    return unless end_date <= start_date

    errors.add(:end_date, 'must be a greater than start date')
  end

  def step_between_start_and_end_date
    return if start_date.nil? || end_date.nil?

    diff = end_date - start_date

    return if (diff % STEP.minutes).zero?

    errors.add(:end_date, 'step between start date must be 30 min')
  end
end
