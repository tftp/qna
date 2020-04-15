require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_other) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #subscribe' do
    context 'as unauthenticate user' do
      it 'responds with error' do
        expect(post :create, params: { question_id: question }, format: :js).to have_http_status(401)
      end
    end

    context 'as authenticate user' do
      before { login(user) }

      it 'user can subscribe if subscription is not exist' do
        post :create, params: { question_id: question }, format: :js
        expect(user.subscriptions.count).to eq 1
      end

      it 'user can not subscribe again if he have this subscription' do
        create(:subscription, user: user, question: question)

        expect{ post :create, params: { question_id: question }, format: :js }.to_not change(Subscription, :count)
      end

      it 'renders create view' do
        post :create, params: { question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #subscribe' do
    let!(:subscription) { create(:subscription, user: user, question: question) }

    context 'as unauthenticate user' do
      it 'responds with error' do
        expect(delete :destroy, params: { id: subscription, question_id: question }, format: :js).to have_http_status(401)
      end
    end

    context 'as authenticate user' do
      before { login(user) }

      it 'user can unsubscribe if he is author of subscription' do
        delete :destroy, params: { id: subscription, question_id: question }, format: :js
        expect(user.subscriptions.count).to eq 0
      end

      it 'user can not unsubscribe if he is not author of subscription' do
        login(user_other)

        expect{ delete :destroy, params: { id: subscription, question_id: question }, format: :js }.to_not change(Subscription, :count)
      end

      it 'renders create view' do
        delete :destroy, params: { id: subscription, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
