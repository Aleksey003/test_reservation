# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'factory' do
    it 'be valid' do
      expect(build(:restaurant)).to be_valid
    end

    it 'be creatable' do
      expect(create(:restaurant)).to be_persisted
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
