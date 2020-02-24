require 'rails_helper'

feature 'User can edit badge to question', %q{
  In order to provide additional into to my question
  As an question's author
  I'd like to be able to edit badge
} do

  scenario 'Unauthenticated user can not edit badge'

  describe 'Authenticated user' do
    scenario 'change the badge when edit question'
    scenario 'can not add bad badge'
    scenario 'can delete badge'
    scenario 'can not add badge in sombody question'
  end
end
