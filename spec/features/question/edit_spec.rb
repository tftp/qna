require 'rails_helper'

feature 'User can edit question', %q{
  as authenticated user
  as author
}do
  given(:author) { create(:user) }
  given(:somebody) { create(:user) }
  given!(:question_somebody) { create(:question, user: somebody) }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    background { sign_in(author) }

    scenario 'can edit question as author', js: true do
      question = create(:question, user: author)
      visit question_path(question)
      click_on(class: 'edit-question-link')
      within '.question' do
        fill_in 'Your question title', with: 'edited question title'
        fill_in 'Your question body', with: 'edited question body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector '#question_body'
      end

    end

    scenario 'can not edit somebody question', js: true do
      visit question_path(question_somebody)

      expect(page).to_not have_link 'Edit'
    end
  end
end
