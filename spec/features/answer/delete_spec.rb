require 'rails_helper'

feature 'User can delete answer', %q{
  if he has author of answer
  as authenticated user
  unauthenticated user can't delete answer
}do

  given(:author) { create(:user) }
  given(:somebody) { create(:user) }
  given(:question) { create(:question, user: somebody) }
  #given!(:answer) { create(:answer, question: question, user: author) }
  scenario 'Authenticated user can delete self answer' do
    answer = create( :answer, question: question, user: author )
    sign_in(author)
    visit question_path(question)
    #save_and_open_page
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user can not delete somebody answer' do
    create( :answer, question: question, user: author )
    sign_in(somebody)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Unauthenticated user can not delete answer' do
    create( :answer, question: question, user: author )
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
