require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  let!(:user) { create(:user, email: 'test@test.com') }

  describe 'GET #new' do
    it 'renders new view' do
      email = 'test@test.com'
      expect(get :new, params: { email: email }).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attribute' do
      context 'if user exists' do
        it 'to not create new user' do
          expect{post :create, params: { email: 'test@test.com' }}.to_not change(User, :count)
        end

        it 'create authorization for user with confirmed_at as nil' do
          expect{post :create, params: { email: 'test@test.com' }, session: {provider: 'facebook'; uid: '123'}}.to change(Authorization, :count).by(1)
        end

        it 'redirect to root path'
      end

      context 'if user not exist' do
        it 'create new user'
        it 'create authorization for user with confirmed_at as nil'
        it 'redirect to root path'
      end
    end

    context 'with invalid attribute' do
      it 'user not created'
      it 'authorization not created'
      it 'render template new'
    end
  end
end
