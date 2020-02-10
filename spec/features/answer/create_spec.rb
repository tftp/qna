require 'rails_helper'

feature 'User can fill form answer', %q{
  on page question
  as authenticated user
  unauthenticated user can't fill form
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'fill in form on page question' do
      within '.answers_form' do
        fill_in 'Body', with: 'NewAnswer'
        click_on 'Reply'
      end

      expect(page).to have_content 'NewAnswer'
    end

    scenario 'fill in form on page question with errors' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'can attached files' do
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Reply'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user can not fill in form', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Body'
    expect(page).to_not have_content 'Reply'
  end
end
