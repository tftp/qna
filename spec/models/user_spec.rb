require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }

  let(:author) { create(:user) }
  let(:somebody) { create(:user) }
  let(:self_question) { create(:question, user: author) }
  let(:somebody_question) { create(:question, user: somebody) }
  let(:self_answer) { create(:answer, question: self_question, user: author) }
  let(:somebody_answer) { create(:answer, question: somebody_question, user: somebody) }

  describe 'is author ' do
    it 'self question' do
        expect(author).to be_is_author(self_question)
    end

    it 'self answer' do
      expect(author).to be_is_author(self_answer)
    end
  end

  describe 'is not author' do
    it 'somebody question' do
      expect(author).not_to be_is_author(somebody_question)
    end

    it 'somebody answer' do
      #можно я это оставлю в качестве примера преобразования?
      #expect(author.is_author?(somebody_answer)).to eq false
      expect(author).not_to be_is_author(somebody_answer)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

    context 'user alredy has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '12345')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user alredy exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: user.email }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'create authorization with provider ans id' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
