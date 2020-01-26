require 'rails_helper'

feature 'User can sign up', %q{
  As an unauthenticated user
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign up' do
    sign_in(user)
    visit root_path

    expect(page).not_to have_selector(:link_or_button, 'Sign Up')
  end
  scenario 'Unregistered user tries to sign up' do
    visit root_path

    click_on 'Sign Up'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    #save_and_open_page

    expect(page).to have_content('You have signed up successfully.')
  end
end
