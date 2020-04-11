require 'rails_helper'
require 'capybara/email/rspec'

feature 'Emailer' do
  describe 'user can receive mail with new daily questions ' do
    given(:user) { create(:user) }
    given!(:question_now) { create(:question, title: 'Question now') }
    given!(:question_old) { create(:question, :old, title: 'Question old') }

    background do
      clear_emails
      DigestMailer.digest(user).deliver_now
      open_email(user.email)
    end

    scenario 'have in his mail new daily questions' do
      expect(current_email).to have_content 'Question now'
    end

    scenario 'have not in his mail old questions' do
      expect(current_email).to_not have_content 'Question old'
    end
  end
end
