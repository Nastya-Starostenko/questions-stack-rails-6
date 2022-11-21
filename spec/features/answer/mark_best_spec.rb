# frozen_string_literal: true

require 'rails_helper'

feature 'User can mark his answer as best', "
  In order to highlighted best answer
  As an author of question
  I'd like to be able to mark any answer as best
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_answers, author: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Mark as best'
  end

  describe 'Authenticated user' do
    background do
      sign_in user

      visit question_path(question)
    end

    scenario 'mark any question as best', js: true do
      within '.answers' do
        page.all('.best-link')[1].click

        expect(page).to have_content 'BEST'
        expect(page).to have_content 'Top answer'
      end
    end

    context 'when another already best' do
      let!(:answer) { create(:answer, question: question, best: true) }
      let!(:new_best_answer) { question.answers.last }

      scenario 'mark any question as best', js: true do
        within '.answers' do
          page.all('.best-link')[1].click

          expect(page).to have_content 'BEST'
          expect(page).to have_content 'Top answer'
        end
        within '.best' do
          expect(page).to have_content new_best_answer.body
        end
      end
    end
  end
end
