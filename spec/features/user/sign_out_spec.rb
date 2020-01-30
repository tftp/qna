require 'rails_helper'

feature 'User can sign out', %q{
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign out' do
    sign_in(user)
    visit root_path
    click_on 'Log Out'
    
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user tries to sign out' do
    visit root_path

    expect(page).not_to have_selector(:link_or_button, 'Log Out')
  end
end
