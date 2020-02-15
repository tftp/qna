require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional into to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:git_url) { 'https://github.com' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My git'
    fill_in 'Url', with: git_url

    click_on 'Ask'

    expect(page).to have_link 'My git', href: git_url
  end
end
