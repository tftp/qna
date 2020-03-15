require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "POST #create" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    context 'as authenticate user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect{post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js}.to change(Comment, :count).by(1)
        end

        it 'comment have valid commentable' do
          post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
          expect(assigns(:comment).commentable_type).to eq 'Question'
          expect(assigns(:comment).commentable_id).to eq question.id
        end

        it 'saves as the comment of correct user' do
          post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js

          created_comment = Comment.order(:created_at).last
          expect(created_comment.user).to eq(user)
        end

        it 'redirect to show comment view' do
          post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect{post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js}.to_not change(Comment, :count)
        end

        it 're-render comment view' do
          post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'as unauthenticate user' do
      it 'does not create the comment' do
        expect{post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js}.to_not change(Comment, :count)
      end

      it 'response unauthorized user' do
        post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end
