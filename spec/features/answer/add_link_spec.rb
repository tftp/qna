require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given(:git_url) {'https://github.com'}
  given(:google_url) { 'http://google.ru' }
  given(:bad_url) { 'http://bad' }

  scenario 'Unauthenticated user can not add links' do
    visit question_path(question)

    expect(page).to_not have_content 'Link name'
    expect(page).to_not have_content 'Url'
  end

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

    scenario 'can add some links', js: true do
      within '.answers_form' do
        fill_in 'Body', with: 'text text text'

        fill_in 'Link name', with: 'My git'
        fill_in 'Url', with: git_url

        within '.link-add' do
          find_link('add link').click
        end

        within all('.nested-fields').last do
          find_field('Link name').set 'Google'
          find_field('Url').set google_url
        end

        click_on 'Reply'
      end

      within '.answers' do
        expect(page).to have_link 'My git', href: git_url
        expect(page).to have_link 'Google', href: google_url
      end
    end
  end
end
