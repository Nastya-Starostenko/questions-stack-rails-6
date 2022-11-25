# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answer', "
  In order to delete answer
  As an user
  I'd like to be able to delete my answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_answers) }

  describe 'Authenticated user', js: true do
    background { sign_in user }

    scenario 'can delete his answer' do
      create(:answer, author: user, question: question)
      visit question_path(question)

      accept_alert do
        click_on 'Delete answer'
      end

      expect(page).to have_content 'Your answer successfully deleted'
    end

    scenario 'can\'t delete question create by other user' do
      visit question_path(question)

      expect(page).not_to have_content 'Delete answer'
    end
  end

  scenario 'Unauthenticated user can\'t delete question create by other user' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete answer'
  end
end
