require 'rails_helper'

feature 'User can create comment' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question_two) { create(:question, user: user) }
  given!(:answer_first) { create(:answer, question: question, user: user) }
  given!(:answer_second) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'make comment for first answer' do
      within ".row-answer[data-answer-id='#{answer_first.id}']" do
        find(".comment-answer-form-#{answer_first.id}").fill_in 'comment_body', with: "AnswerFirst"
        click_on 'Add comment'

        expect(page).to have_content 'AnswerFirst'
      end
    end

    scenario 'make comment for second answer' do
      within ".row-answer[data-answer-id='#{answer_second.id}']" do
        find(".comment-answer-form-#{answer_second.id}").fill_in 'comment_body', with: "AnswerSecond"
        click_on 'Add comment'

        expect(page).to have_content 'AnswerSecond'
      end
    end

    scenario 'make comment with error' do
      within ".row-answer[data-answer-id='#{answer_first.id}']" do
        click_on 'Add comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'can not to make a comment' do
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
        within ".row-answer[data-answer-id='#{answer_first.id}']" do
          find(".comment-answer-form-#{answer_first.id}").fill_in 'comment_body', with: "AnswerFirst"
          click_on 'Add comment'

          expect(page).to have_content 'AnswerFirst'
        end
      end

      Capybara.using_session('quest') do
        expect(page).to have_content 'AnswerFirst'
      end
    end

    scenario 'comment to answer not appears on another question page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('quest') do
        visit question_path(question_two)
      end

      Capybara.using_session('user') do
        within ".row-answer[data-answer-id='#{answer_first.id}']" do
          find(".comment-answer-form-#{answer_first.id}").fill_in 'comment_body', with: "AnswerFirst"
          click_on 'Add comment'

          expect(page).to have_content 'AnswerFirst'
        end
      end

      Capybara.using_session('quest') do
        expect(page).to_not have_content 'AnswerFirst'
      end
    end
  end
end
