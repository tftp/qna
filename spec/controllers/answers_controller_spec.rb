require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'GET #new' do
    context 'as authenticate_user' do
      before { login(author) }
      before { get :new, params: {question_id: question} }

      it 'assigns a new Answer to @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'as unauthenticate_user' do
      before { get :new, params: {question_id: question} }

      it 'not assigns a new Answer to @answer' do
        expect(assigns(:answer)).not_to be_a_new(Answer)
      end

      it 'redirect to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(author) }

      it 'saves a new answer in the database' do
        expect{post :create, params: { answer: attributes_for(:answer), question_id: question }}.to change(question.answers, :count).by(1)
      end

      it 'redirect to show question view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { login(author) }

      it 'does not save the question' do
        expect{post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }}.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end

    context "as unauthenticate user" do
      it 'does not create the question' do
        expect{post :create, params: { answer: attributes_for(:answer), question_id: question }}.to_not change(Answer, :count)
      end

      it 'redirect to sign in page' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: author, question: question) }

    context 'as author' do
      before { login(author) }

      it 'deletes the answer' do
        expect{delete :destroy, params: { id: answer, question_id: question }}.to change(Answer, :count).by(-1)
      end

      it 'redirect to answers' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'as not author' do
      before { login(user) }

      it "can't deletes the answer" do
        expect{delete :destroy, params: { id: answer, question_id: question }}.to_not change(Answer, :count)
      end

      it 'redirect to answers' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'as not unauthenticate user' do

      it "can't deletes the answer" do
        expect{delete :destroy, params: { id: answer, question_id: question }}.to_not change(Answer, :count)
      end

      it 'redirect to sign in page' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
