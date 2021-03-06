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
  given!(:answer) { create(:answer, question: question_somebody, user: author) }

  scenario "Unauthenticated user can't select answer as best" do
    visit question_path(question_somebody)

    expect(page).to_not have_content 'false'
    expect(page).to_not have_content 'true'
  end

  describe 'Authenticated user', js: true do
    context 'can select answer as best' do
      given!(:answer) { create(:answer, question: question_author, user: author) }

      scenario ' as author question' do
        sign_in(author)
        visit question_path(question_author)

        expect(page).to have_button 'false'
        click_button 'false'

        expect(page).to have_button 'true'
      end
    end

    scenario 'can not select answer as best somebody question' do
      sign_in(author)
      visit question_path(question_somebody)

      expect(page).to_not have_button 'false'
      expect(page).to_not have_button 'true'
    end
  end

  describe 'OLD author can', js: true do
    given!(:answer_one) { create(:answer, :best, question: question_author, user: somebody) }
    given!(:answer_two) { create(:answer, question: question_author, user: somebody) }

    background do
      sign_in(author)
      visit question_path(question_author)
    end

    scenario 'reselect beter answer' do
      # для примера оставлю два разных варианта
      expect(page).to have_selector("input.best-answer-link[data-answer-id='#{answer_one.id}']"), text: "true"
      find("input.best-answer-link[data-answer-id='#{answer_two.id}']").has_text? "false"

      click_button 'false'

      find("input.best-answer-link[data-answer-id='#{answer_one.id}']").has_text? "false"
      find("input.best-answer-link[data-answer-id='#{answer_two.id}']").has_text? "true"
    end

    scenario 'select beter answer and it has be on top' do
      within all('.row-answer')[0] do
        expect(page).to have_css '.btn-success'
      end
      within all('.row-answer')[1] do
        expect(page).to have_css '.btn-secondary'
      end
      click_button 'false'
      within all('.row-answer')[0] do
        expect(page).to have_css '.btn-success'
      end
      within all('.row-answer')[1] do
        expect(page).to have_css '.btn-secondary'
      end
    end
  end
end
