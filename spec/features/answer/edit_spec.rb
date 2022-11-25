# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_second) { create(:user) }
  given!(:answer) { create(:answer, author: user, question: question) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in user

      visit question_path(question)
    end

    scenario 'edit his answer with valid data', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content 'Body can\'t be blank'
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
