require 'rails_helper'

feature 'User can create comment' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'make comment for question' do
      within '.question' do
        find('.comment-question-form').fill_in 'comment_body', with: "By-by"
        click_on 'Add comment'

        expect(page).to have_content 'By-by'
        end
    end

    scenario 'make comment with error' do
      within '.question' do
        click_on 'Add comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to make a comment' do
      expect(page).to_not have_content 'Add comment'
    end
  end

  describe 'multiple sessions', js: true do
    scenario 'comment to answer appears on another users page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('quest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          find('.comment-question-form').fill_in 'comment_body', with: "By-by"
          click_on 'Add comment'

          expect(page).to have_content 'By-by'
          end
      end

      Capybara.using_session('quest') do
        expect(page).to have_content 'By-by'
      end
    end
  end
end
