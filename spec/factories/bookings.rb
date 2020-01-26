# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    user
    table
    start_date { '2020-01-01 12:00:00' }
    end_date { '2020-01-01 12:30:00' }
  end
end
