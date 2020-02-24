require 'rails_helper'

feature 'User can edit links to question', %q{
  In order to provide editional into my question
  As an question's author
  I'd like to be able to edit links
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question_somebody) { create(:question, user: user) }
  given(:question) { create(:question, user: author) }
  given(:git_url) { 'https://github.com' }
  given(:google_url) { 'http://google.ru' }
  given(:bad_url) { 'http://bad' }

  scenario 'Unauthenticated user can not edit links' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in(author)
      question.links.create(name: 'Google', url: google_url)
      visit question_path(question)
    end

    scenario 'change the link when edit question', js: true do

      expect(page).to have_link 'Google', href: google_url

      within '.question' do
        click_on(class: 'edit-question-link')
        fill_in 'Your question title', with: 'edited question title'
        fill_in 'Your question body', with: 'edited question body'

        fill_in 'Link name', with: 'My git'
        fill_in 'Url', with: git_url

        click_on 'Save'
      end

      expect(page).to_not have_link 'Google', href: google_url
      expect(page).to have_link 'My git', href: git_url
    end

    scenario 'can add link when edit question', js: true do

      expect(page).to have_link 'Google', href: google_url

      within '.question' do
        click_on(class: 'edit-question-link')
        fill_in 'Your question title', with: 'edited question title'
        fill_in 'Your question body', with: 'edited question body'

        within '.link-add' do
          find_link('add link').click
        end

        within all('.nested-fields').last do
          find_field('Link name').set 'My git'
          find_field('Url').set git_url
        end

        click_on 'Save'

        expect(page).to have_link 'Google', href: google_url
        expect(page).to have_link 'My git', href: git_url
      end
    end

    scenario 'can not add bad link', js: true do

      expect(page).to have_link 'Google', href: google_url

      within '.question' do
        click_on(class: 'edit-question-link')
        fill_in 'Your question title', with: 'edited question title'
        fill_in 'Your question body', with: 'edited question body'

        fill_in 'Link name', with: 'Bad'
        fill_in 'Url', with: bad_url

        click_on 'Save'
      end

      expect(page).to_not have_link 'Bad', href: bad_url
      expect(page).to have_link 'Google', href: google_url
    end

    scenario 'can delete link', js: true do

      expect(page).to have_link 'Google', href: google_url

      within '.question' do
        click_on(class: 'edit-question-link')

        within '.link-remove' do
          find_link('remove link').click
        end
        click_on 'Save'
      end

      expect(page).to_not have_link 'Google', href: google_url
    end

    scenario 'can not add link in sombody question', js: true do
      visit question_path(question_somebody)

      expect(page).to_not have_link 'Edit'
    end
  end
end
