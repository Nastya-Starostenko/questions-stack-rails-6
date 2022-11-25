# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign-out', "
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in user

    click_on 'Sign Out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user can\'t see sign out link' do
    visit root_path
    expect(page).not_to have_content 'Sign Out'
  end
end
