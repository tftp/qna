require 'rails_helper'

feature 'User can show question with his answers', %q{
  as authenticated user
  as unauthenticated user
}do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { question.answers.create( body: 'MyAnswer' ) }

  #background { visit question_path }

  scenario 'Authenticated user can show question and his answers' do
    #question.answers.create(body: 'MyAnswer')
    sign_in(user)
    visit "/questions/#{question.id}"
    #save_and_open_page
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    expect(page).to have_content 'MyAnswer'

  end

  scenario 'Unauthenticated user can show question and his answers' do
    visit "/questions/#{question.id}"
    #save_and_open_page
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    expect(page).to have_content 'MyAnswer'
  end
end
