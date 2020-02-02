require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
}do

  given(:author) { create(:user) }
  given(:somebody) { create(:user) }
  given(:question) { create(:question, user: somebody) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edit his answer', js: true do
      answer = create(:answer, question: question, user: author)
      sign_in(author)
      visit question_path(question)

      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'text_area'
      end
    end

    scenario 'edit his answer with error', js: true do
      answer = create(:answer, question: question, user: author)
      sign_in(author)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ' '
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to_not have_selector 'text_area'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries edit other user's answers", js: true do
      answer = create(:answer, question: question, user: somebody)
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Edit'
    end
  end
end
