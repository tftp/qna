require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given(:git_url) {'https://github.com'}
  given(:bad_url) { 'http://bad' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User adds link when give an answer', js: true do
      within '.answers_form' do
        fill_in 'Body', with: 'NewAnswer'

        fill_in 'Link name', with: 'My git'
        fill_in 'Url', with: git_url

        click_on 'Reply'
      end

      expect(page).to have_link 'My git', href: git_url
    end

    scenario 'can not add bad link', js: true do
      within '.answers_form' do
        fill_in 'Body', with: 'NewAnswer'

        fill_in 'Link name', with: 'Bad'
        fill_in 'Url', with: bad_url

        click_on 'Reply'
      end

      expect(page).to_not have_link 'Bad link', href: bad_url
      expect(page).to have_content 'Links url is invalid'
    end
  end
end
