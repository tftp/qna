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
    visit "/questions/#{question.id}"
    fill_in 'Body', with: 'NewAnswer'
    click_on 'Reply'

    expect(page).to have_content 'NewAnswer'
    expect(page).to have_content 'Your answer successfully created'
  end

  scenario 'Authenticated user fill in form on page question with errors' do
    sign_in(user)
    visit "/questions/#{question.id}"
    click_on 'Reply'
    #save_and_open_page

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Unauthenticated user can not fill in form' do
    visit "/questions/#{question.id}"
    fill_in 'Body', with: 'NewAnswer'
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
