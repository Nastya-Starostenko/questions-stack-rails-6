# frozen_string_literal: true

require 'rails_helper'

feature 'User can give an answer', "
  In order to give answer to a community
  As an authenticated user
  I'd like to be able to give answer for the question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_answers) }

  describe 'Authenticated user', js: true do
    background do
      sign_in user

      visit question_path(question)
    end

    scenario 'can create an answer' do
      fill_in 'Your answer', with: 'text text text'
      click_on 'Answer'

      expect(page).to have_current_path question_path(question), ignore_query: true
      expect(page).to have_content 'Your answer successfully created'

      within '.answers' do
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'answer to a question with errors' do
      click_on 'Answer'

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  scenario 'Unauthenticated user tries to answer to a question' do
    visit question_path(question)

    fill_in 'Your answer', with: 'text text text'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
