# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'factory' do
    it 'be valid' do
      expect(build(:booking)).to be_valid
    end

    it 'be creatable' do
      expect(create(:booking)).to be_persisted
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }

    describe 'end_date_greater then start_date' do
      subject { build(:booking, start_date: start_date, end_date: end_date) }
      let(:start_date) { Time.zone.parse('2020-01-01 12:00:00 UTC') }

      context 'when end_date less than start_date' do
        let(:end_date) { start_date - 1.second }

        it do
          is_expected.to_not allow_value(end_date).for(:end_date)
                                                  .with_message('must be a greater than start date')
        end
      end

      context 'when end_date equals start_date' do
        let(:end_date) { start_date }

        it do
          is_expected.to_not allow_value(end_date).for(:end_date)
                                                  .with_message('must be a greater than start date')
        end
      end
    end

    describe 'step between start & end dates' do
      subject { build(:booking, start_date: start_date, end_date: end_date) }
      let(:start_date) { Time.zone.parse('2020-01-01 16:34:18 UTC') }
      let(:end_date) { start_date + interval }

      context 'when 30 min' do
        let(:interval) { 30.minutes }

        it do
          is_expected.to allow_value(end_date).for(:end_date)
        end
      end

      context 'when 60 min' do
        let(:interval) { 60.minutes }

        it do
          is_expected.to allow_value(end_date).for(:end_date)
        end
      end

      context 'when 1 min' do
        let(:interval) { 1.minutes }

        it do
          is_expected.to_not allow_value(end_date).for(:end_date)
                                                  .with_message('step between start date must be 30 min')
        end
      end
    end

    describe 'reservation availability' do
      subject { build(:booking, table: table, start_date: start_date, end_date: end_date) }

      let(:table) { existing_booking.table }

      let!(:existing_booking) do
        create(:booking,
               start_date: Time.zone.parse('2020-01-01 16:00:00 UTC'),
               end_date: Time.zone.parse('2020-01-01 19:00:00 UTC'))
      end

      let(:start_date) { existing_booking.start_date }
      let(:end_date) { existing_booking.end_date }

      context 'when within different table' do
        let(:table) { create(:table) }

        it do
          is_expected.to be_valid
        end
      end

      context 'when dates are availabled' do
        let(:start_date) { existing_booking.end_date + 1.hour }
        let(:end_date) { start_date + 1.hour }

        it do
          is_expected.to be_valid
        end
      end

      context 'when existing end_date and new start_date are equal' do
        let(:start_date) { existing_booking.end_date }
        let(:end_date) { start_date + 1.hour }

        it do
          is_expected.to be_valid
        end
      end

      context 'when existing end new dates equal' do
        let(:start_date) { existing_booking.start_date }
        let(:end_date) { existing_booking.end_date }

        it do
          is_expected.to be_invalid
          expect(subject.errors[:base]).to eq ['dates are not available']
        end
      end

      context 'when both existing and new dates are overlapped' do
        let(:start_date) { existing_booking.start_date + 1.hour }
        let(:end_date) { start_date + 1.hour }

        it do
          is_expected.to be_invalid
          expect(subject.errors[:base]).to eq ['dates are not available']
        end
      end

      context 'when existing and new start dates are overlapped' do
        let(:start_date) { existing_booking.end_date - 1.minute }
        let(:end_date) { start_date + 1.hour }

        it do
          is_expected.to be_invalid
          expect(subject.errors[:base]).to eq ['dates are not available']
        end
      end
    end
  end
end
