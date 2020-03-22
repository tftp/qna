require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
#    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Provider with email' do
    let!(:oauth_data) { { 'provider' => 'facebook', 'uid' => 12345, 'info' => { 'email' => 'user@qna.com' } } }

    it 'finds user from oauth data' do
#      allow(request.env).to receive(:[]).and_call_original
#      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(Services::FindForOauth).to receive(:new).with(oauth_data).and_return(FindForOauth)
      get :facebook
    end

    context 'authorization exist' do
      let(:user) { create(:user) }
      let!(:authorization) { create(:authorization, user: user, provider: 'facebook', uid: '12345') }

      before do
        allow(Services::FindForOauth).to receive(:new).with(oauth_data).and_return(authorization)
        get :facebook
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end
end
