require 'rails_helper'

feature 'User can edit links to answer', %q{
  In order to provide editional into answer
  As an answers's author
  I'd like to be able to edit links
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }
  given(:answer_somebody) { create(:answer, question: question, user: user) }
  given(:git_url) { 'https://github.com' }
  given(:google_url) { 'http://google.ru' }
  given(:bad_url) { 'http://bad' }
  given(:ya_url) { 'http://ya.ru' }

  scenario 'Unauthenticated user can not edit links' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(author)
      answer.links.create(name: 'Google', url: google_url)
      answer_somebody.links.create(name: 'Yandex', url: ya_url)
      visit question_path(question)
    end

    scenario 'change the link when edit answer', js: true do

      expect(page).to have_link 'Google', href: google_url

      within '.answers' do
        click_on(class: 'edit-answer-link')

        fill_in 'Your answer', with: 'edited answer'

        fill_in 'Link name', with: 'My git'
        fill_in 'Url', with: git_url

        click_on 'Save'
      end

      expect(page).to_not have_link 'Google', href: google_url
      expect(page).to have_link 'My git', href: git_url
    end

    scenario 'can add link when edit answer', js: true do

      expect(page).to have_link 'Google', href: google_url

      within '.answers' do
        click_on(class: 'edit-answer-link')
        fill_in 'Your answer', with: 'edited answer'

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

      within '.answers' do
        click_on(class: 'edit-answer-link')

        fill_in 'Your answer', with: 'edited answer'

        fill_in 'Link name', with: 'Bad'
        fill_in 'Url', with: bad_url

        click_on 'Save'
      end

      expect(page).to have_link 'Google', href: google_url
      expect(page).to_not have_link 'Bad', href: bad_url
    end

    scenario 'can delete link', js: true do
      expect(page).to have_link 'Google', href: google_url

      within '.answers' do
        click_on(class: 'edit-answer-link')

        within '.link-remove' do
          find_link('remove link').click
        end

        click_on 'Save'
      end

      expect(page).to_not have_link 'Google', href: google_url
    end

    scenario 'can not add link in somebody question', js: true do
      visit question_path(question)

      within ".row-answer[data-answer-id='#{answer_somebody.id}']" do
        expect(page).to have_link 'Yandex', href: ya_url
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
