# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Table, type: :model do
  describe 'factory' do
    it 'be valid' do
      expect(build(:table)).to be_valid
    end

    it 'be creatable' do
      expect(create(:table)).to be_persisted
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
