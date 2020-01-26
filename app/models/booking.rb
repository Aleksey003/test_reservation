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

  validate :dates_availability

  scope :within_dates, ->(start_date, end_date) do
    where(start_date: start_date..end_date, end_date: start_date..end_date)
  end

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

  def dates_availability
    return if end_date.nil? || start_date.nil?

    booked_ranges = table.bookings.within_dates(restaurant_schedule.start, restaurant_schedule.end).map { |reservation| reservation.start_date...reservation.end_date }

    booked_ranges.each do |range|
      if range.include?(start_date) || range.include?(end_date)
        errors.add(:base, 'dates are not available')
      end
    end
  end

  def restaurant_schedule #FIXME
    OpenStruct.new(start: start_date.beginning_of_day, end: start_date.end_of_day)
  end
end
