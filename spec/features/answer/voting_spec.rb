require 'rails_helper'

feature 'User can vote for answer', %q{
  As not an answer's author
} do

  given(:user) {create(:user)}
  given(:author) {create(:user)}
  given(:question) {create(:question, user: user)}
  given!(:answer) {create(:answer, question: question, user: user)}
  given!(:answer_author) {create(:answer, question: question, user: author)}

  scenario 'Unauthenticated user can not vote' do
    visit question_path(question)

    expect(page).to_not have_content 'plus'
    expect(page).to_not have_content 'minus'

  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(author)
      visit question_path(question)
    end
    scenario 'can vote as not author' do
      within ".row-answer[data-answer-id='#{answer.id}']" do
        expect(page).to have_content '0'

        click_link 'minus'

        expect(page).to have_content '-1'
      end
    end

    scenario 'can reset vote as not author' do
      within ".row-answer[data-answer-id='#{answer.id}']" do
        expect(page).to have_content '0'

        click_link 'plus'

        expect(page).to have_content '1'

        click_link 'plus'

        expect(page).to have_content '0'
      end
    end

    scenario 'can not vote as author' do
      within ".row-answer[data-answer-id='#{answer_author.id}']" do

        expect(page).to_not have_link 'plus'
      end
    end
  end
end
