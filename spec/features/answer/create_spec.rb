require 'rails_helper'

feature 'User can fill form answer', %q{
  on page question
  as authenticated user
  unauthenticated user can't fill form
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user fill in form on page question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'NewAnswer'
    click_on 'Reply'

    expect(page).to have_content 'NewAnswer'
    expect(page).to have_content 'Your answer successfully created'
  end

  scenario 'Authenticated user fill in form on page question with errors' do
    sign_in(user)
    visit question_path(question)
    #save_and_open_page
    click_on 'Reply'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Unauthenticated user can not fill in form' do
    visit question_path(question)

    expect(page).to_not have_content 'Body'
    expect(page).to_not have_content 'Reply'
  end
end
