require 'sphinx_helper'

feature 'User can search' do
  given!(:user) { create(:user, email: 'test@test.ru') }
  given!(:question) { create(:question, body: 'test question') }
  given!(:answer) { create(:answer, body: 'test answer', question: question) }
  given!(:comment) { create(:comment, body: 'test comment', commentable: question, user: user) }



  scenario 'for questions body', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'query', with: 'test'
        find(:select).find(:option, 'question').select_option
        click_on "Search"
      end

      expect(page).to have_content question.body
    end
  end

  scenario 'for answers body', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'query', with: 'test'
        find(:select).find(:option, 'answer').select_option
        click_on "Search"
      end

      expect(page).to have_content answer.body
    end
  end

  scenario 'for comments body', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'query', with: 'test'
        find(:select).find(:option, 'comment').select_option
        click_on "Search"
      end

      expect(page).to have_content comment.body
    end
  end

  scenario 'for users email', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'query', with: 'test'
        find(:select).find(:option, 'user').select_option
        click_on "Search"
      end

      expect(page).to have_content user.email
    end
  end

  scenario 'for all', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'query', with: 'test'
        find(:select).find(:option, 'all').select_option
        click_on "Search"
      end

      expect(page).to have_content question.body
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to have_content user.email
    end
  end
end
