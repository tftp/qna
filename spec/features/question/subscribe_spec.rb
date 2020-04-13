require 'rails_helper'

feature 'User can subscribe question' do

  given(:user) {create(:user)}
  given(:question) {create(:question, user: user)}

  scenario 'Unauthenticated user can not subscribe' do
    visit question_path(question)

    expect(page).to_not have_content 'subscribe'
    expect(page).to_not have_content 'unsubscribe'
  end

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'can unsubscribe' do
      visit question_path(question)

      within '.question' do
        click_link 'subscribe'

        expect(page).to have_content 'unsubscribe'
      end
    end

    scenario 'can subscribe' do
      user.subscriptions << question
      visit question_path(question)

      within '.question' do
        click_link 'unsubscribe'

        expect(page).to have_content 'subscribe'
      end
    end

    scenario 'when user create new question, he is subscribed' do
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'unsubscribe'
    end
  end
end
