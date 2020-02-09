require 'rails_helper'

feature 'User can delete answer', %q{
  if he has author of answer
  as authenticated user
  unauthenticated user can't delete answer
}do

  given(:author) { create(:user) }
  given(:somebody) { create(:user) }
  given(:question) { create(:question, user: somebody) }
  given!(:answer) { create(:answer, question: question, user: author) }

  context 'Authenticated user can delete' do
    given!(:answer_somebody) { create(:answer, question: question, user: somebody) }

    scenario 'only self answer but not of somebody answer', js: true do
      sign_in(author)
      visit question_path(question)
      click_on 'Delete'

      expect(page).to_not have_content answer.body
      expect(page).to have_content answer_somebody.body
    end
  end

  scenario 'Authenticated user can not delete somebody answer', js: true do
    sign_in(somebody)
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end

  scenario 'Unauthenticated user can not delete answer', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end
end
