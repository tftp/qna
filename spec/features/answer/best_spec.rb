require 'rails_helper'

feature 'User can select answer as best', %q{
  if he has author of question of answers
  as authenticated user
  unauthenticated user can't select answer
}do

  given(:somebody) { create(:user) }
  given(:author) { create(:user) }
  given(:question_author) { create(:question, user: author) }
  given(:question_somebody) { create(:question, user: somebody) }

  scenario "Unauthenticated user can't select answer as best" do
    answer = create(:answer, question: question_somebody, user: author)
    visit question_path(question_somebody)

    expect(page).to_not have_content 'false'
    expect(page).to_not have_content 'true'
  end

  describe 'Authenticated user', js: true do
    scenario 'can select answer as best as author question' do
      answer_somebody = create(:answer, question: question_author, user: somebody)
      sign_in(author)
      visit question_path(question_author)

      expect(page).to have_content 'false'
      click_on 'false'
      wait_for_ajax

      expect(page).to have_content 'true'
    end

    scenario 'can not select answer as best somebody question' do
      answer = create(:answer, question: question_somebody, user: author)
      sign_in(author)
      visit question_path(question_somebody)

      expect(page).to_not have_content 'false'
      expect(page).to_not have_content 'true'
    end
  end
end
