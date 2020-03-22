require 'rails_helper'

feature 'User can authorization through OmniAuth providers', %q{
} do
  describe 'access through Github' do
    scenario 'user not exist and can sign in' do
      visit new_user_session_path
      page.should have_content("Sign in with GitHub")
      mock_auth_hash_github
      click_link "Sign in with GitHub"
      page.should have_content("Log Out")
    end

    scenario 'user exist and can sign in' do
      create(:user, email: 'test@github.com')

      visit new_user_session_path
      page.should have_content("Sign in with GitHub")
      mock_auth_hash_github
      click_link "Sign in with GitHub"
      page.should have_content("Log Out")
    end

    scenario 'can not sign in if authentication error' do
      visit new_user_session_path
      page.should have_content("Sign in with GitHub")
      mock_auth_hash_github_invalid
      click_link "Sign in with GitHub"
      page.should have_content('Could not authenticate you from GitHub')
    end
  end

  describe 'access user through Facebook' do
    scenario 'user not exist and can sign in' do
      visit new_user_session_path
      page.should have_content("Sign in with Facebook")
      mock_auth_hash_facebook
      click_link "Sign in with Facebook"
      page.should have_content("Log Out")
    end

    scenario 'user exist and can sign in' do
      create(:user, email: 'test@facebook.com')

      visit new_user_session_path
      page.should have_content("Sign in with Facebook")
      mock_auth_hash_github
      click_link "Sign in with Facebook"
      page.should have_content("Log Out")
    end

    scenario 'can not sign in if authentication error' do
      visit new_user_session_path
      page.should have_content("Sign in with Facebook")
      mock_auth_hash_facebook_invalid
      click_link "Sign in with Facebook"
      page.should have_content('Could not authenticate you from Facebook')
    end
  end
end
