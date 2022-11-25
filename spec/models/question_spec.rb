# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question do
  describe 'relations' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to belong_to(:author).class_name('User') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
  end
end
