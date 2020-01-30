require 'rails_helper'

feature 'User can show question with his answers', %q{
  as authenticated user
  as unauthenticated user
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question, user: user) }

  scenario 'Authenticated user can show question and his answers' do
    sign_in(user)
    visit visit question_path(question)

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Unauthenticated user can show question and his answers' do
    visit question_path(question)

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
