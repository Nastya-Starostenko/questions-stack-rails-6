# frozen_string_literal: true

require 'rails_helper'

feature 'User can view list of answers on the question page', "
  In order to see answers from a community
  As an user
  I'd like to be able to see the question and answers
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_answers) }
  given!(:answers) { question.answers }

  scenario 'Authenticated user sees answers for the question' do
    sign_in user
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Unauthenticated user sees answers for question' do
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
