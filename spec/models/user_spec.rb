# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'relations' do
    it { is_expected.to have_many(:authored_questions).class_name('Question').dependent(:nullify) }
    it { is_expected.to have_many(:authored_answers).class_name('Answer').dependent(:nullify) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
  end
end
