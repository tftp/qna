require 'rails_helper'

RSpec.describe Services::FindForOauth do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }
    subject { Services::FindForOauth.new(auth) }

    context 'user alredy has authorization' do
      let!(:authorization) { create(:authorization, user: user, provider: 'facebook', uid: '12345') }
      it 'returns the users authorization' do
        expect(subject.call).to eq user.authorizations.last
      end
    end

    context 'user has not authorization and OmniAuths response has email' do
      context 'user alredy exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: user.email }) }

        it 'does not create new user' do
          expect { subject.call }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { subject.call }.to change(user.authorizations, :count).by(1)
        end

        it 'create authorization with provider and id' do
          authorization = subject.call

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the authorization' do
          expect(subject.call).to be_a(Authorization)
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { subject.call }.to change(User, :count).by(1)
        end

        it 'returns authorization' do
          expect(subject.call).to be_a(Authorization)
        end

        it 'authorization has the user with his email' do
          authorization = subject.call
          expect(authorization.user.email).to eq auth.info[:email]
        end

        it 'creates authorization with provider and uid' do
          authorization = subject.call

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  context 'user has not authorization and OmniAuths response has not email' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

    it 'return authorization has nil' do
      authorization = subject.call

      expect(authorization).to eq nil
    end

    it 'to not create new user' do
      expect { subject.call }.to_not change(User, :count)
    end
  end
end
