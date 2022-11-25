# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete question', "
  In order to delete question
  As an user
  I'd like to be able to delete my question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:another_question) { create(:question) }

  describe 'Authenticated user' do
    background { sign_in user }

    scenario 'can delete his question' do
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted'
    end

    scenario 'can\'t delete question create by other user' do
      visit question_path(another_question)

      expect(page).not_to have_content 'Delete question'
    end
  end

  scenario 'Unauthenticated user can\'t delete question create by other user' do
    visit question_path(question)
    expect(page).not_to have_content 'Delete question'
  end
end
