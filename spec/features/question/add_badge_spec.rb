require 'rails_helper'

feature 'User can add badge to question', %q{
  In order to provide additional into to my question
  As an question's author
  I'd like to be able to add badge
} do

  given(:user) { create(:user) }

  scenario 'Unauthenticated user can not add badge' do
    visit new_question_path

    expect(page).to_not have_content 'Badge'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'adds badge when asks question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Badge name', with: 'My badge'
      attach_file 'File', "#{Rails.root}/public/foto_01.jpg"

      click_on 'Ask'

      expect(page).to have_css('.img-badge')
    end

    scenario 'can not add bad badge' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Badge name', with: 'My badge'

      click_on 'Ask'

      expect(page).to_not have_css('.img-badge')
    end
  end
end
