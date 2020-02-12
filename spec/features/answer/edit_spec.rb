require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
}do

  given(:author) { create(:user) }
  given(:somebody) { create(:user) }
  given(:question) { create(:question, user: somebody) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Unauthenticated user' do
    scenario 'can not edit answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end

    scenario 'can not delete atached file' do
      visit question_path(question)

      expect(page).to_not have_link(class: 'delete-file-link')
    end
  end

  describe 'Authenticated user', js: true do
    scenario 'edit his answer' do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do

        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'text_area'
      end
    end

    scenario 'edit his answer with error' do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ' '
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to_not have_selector 'text_area'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries edit other user's answers" do
      sign_in(somebody)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content answer.body
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'can attached files' do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'delete attached file' do
      sign_in(author)

      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      visit question_path(question)
      within '.answers' do
        click_link(class: 'delete-file-link')

        expect(page).to_not have_link 'rails_helper.rb'
      end
    end
  end
end
