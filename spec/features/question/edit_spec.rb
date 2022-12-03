# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an authenticated user
  I'd like to be able to edit my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_attachment, author: user) }
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

    scenario 'edit his question with valid data and attached files', js: true do
      within '.question-body' do
        click_on 'Edit'
        fill_in 'Title', with: 'edited title'
        attach_file 'File', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
        click_on 'Update'

        expect(page).not_to have_content question.title
        expect(page).to have_content 'edited title'
        expect(page).not_to have_selector 'textarea'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'delete attached file', js: true do
      within '.question-body' do
        accept_alert do
          click_on 'Delete'
        end
      end
      expect(page).to have_content 'Your attachment was successfully deleted'
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
