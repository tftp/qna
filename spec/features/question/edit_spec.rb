require 'rails_helper'

feature 'User can edit question', %q{
  as authenticated user
  as author
}do
  given(:author) { create(:user) }
  given(:somebody) { create(:user) }
  given!(:question_somebody) { create(:question, user: somebody) }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background { sign_in(author) }

    context 'can edit question' do
      given!(:question) { create(:question, user: author) }

      scenario 'as author' do
        visit question_path(question)
        click_on(class: 'edit-question-link')

        within '.question' do
          fill_in 'Your question title', with: 'edited question title'
          fill_in 'Your question body', with: 'edited question body'
          click_on 'Save'

          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited question title'
          expect(page).to have_content 'edited question body'
          expect(page).to_not have_selector '#question_body'
        end
      end

      scenario 'with attached files' do
        visit question_path(question)
        click_on(class: 'edit-question-link')

        within '.question' do
          fill_in 'Your question title', with: 'edited question title'
          fill_in 'Your question body', with: 'edited question body'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end        
      end
    end

    scenario 'can not edit somebody question' do
      visit question_path(question_somebody)

      expect(page).to_not have_link 'Edit'
    end
  end
end
