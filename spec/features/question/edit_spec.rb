# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an authenticated user
  I'd like to be able to edit my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:user_second) { create(:user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in user

      visit question_path(question)
    end

    scenario 'edit his question with valid data', js: true do
      within '.question-body' do
        click_on 'Edit'
        fill_in 'Title', with: 'edited title'
        click_on 'Update'

        expect(page).not_to have_content question.title
        expect(page).to have_content 'edited title'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors', js: true do
      within '.question-body' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Update'

        expect(page).to have_content 'Title can\'t be blank'
      end
    end

    scenario 'tries to edit other user\'s answer' do
      click_link 'Sign Out'

      sign_in user_second
      visit question_path(question)
      expect(page).not_to have_content 'Edit'
    end
  end
end
