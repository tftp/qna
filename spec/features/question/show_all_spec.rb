require 'rails_helper'

feature 'User can show list of questions', %q{
  As an authenticated user
  As an unauthenticated user
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, user: user) }

  scenario 'Authenticated user can show list questions' do
    sign_in(user)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'Unauthenticated user can show list questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
