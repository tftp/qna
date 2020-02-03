require 'rails_helper'

feature 'User can delete question', %q{
  if he has author of question
  as authenticated user
  unauthenticated user can't delete question
}do

  given(:author) { create(:user) }
  given(:somebody) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Authenticated user can delete self question' do
    sign_in(author)
    visit questions_path

    expect(page).to have_content question.title
    click_on 'Delete'

    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user can not delete somebody question' do
    sign_in(somebody)
    visit questions_path

    expect(page).to_not have_content 'Delete'
  end

  scenario 'Unauthenticated user can not delete question' do
    visit questions_path

    expect(page).to_not have_content 'Delete'
  end
end
