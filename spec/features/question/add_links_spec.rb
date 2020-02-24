require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional into to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:git_url) { 'https://github.com' }
  given(:google_url) { 'http://google.ru' }
  given(:bad_url) { 'http://bad' }

  scenario 'Unauthenticated user can not add links' do
    visit new_question_path

    expect(page).to_not have_content 'Link name'
    expect(page).to_not have_content 'Url'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'adds link when asks question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My git'
      fill_in 'Url', with: git_url

      click_on 'Ask'

      expect(page).to have_link 'My git', href: git_url
    end

    scenario 'can add some links', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My git'
      fill_in 'Url', with: git_url

      within '.link-add' do
        find_link('add link').click
      end

      #оставлю эту конструкцию для примера поиска повторяющихся элементов
      find_all('.nested-fields').count

      within all('.nested-fields').last do
        find_field('Link name').set 'Google'
        find_field('Url').set google_url
      end

      click_on 'Ask'

      expect(page).to have_link 'My git', href: git_url
      expect(page).to have_link 'Google', href: google_url
    end

    scenario 'can not add bad link' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'Bad link'
      fill_in 'Url', with: bad_url

      click_on 'Ask'

      expect(page).to_not have_link 'Bad link', href: bad_url
      expect(page).to have_content 'Links url is invalid'
    end
  end
end
