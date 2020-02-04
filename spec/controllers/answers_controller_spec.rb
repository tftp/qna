require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:question_somebody) { create(:question, user: user) }

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
        expect{post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'answer have valid author' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(assigns(:answer).user).to eq author
      end

      it 'redirect to show question view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(author) }

      it 'does not save the question' do
        expect{post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
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
        expect{delete :destroy, params: { id: answer, question_id: question }, format: :js}.to change(Answer, :count).by(-1)
      end

      it 'render template delete' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'as not author' do
      before { login(user) }

      it "can't deletes the answer" do
        expect{delete :destroy, params: { id: answer, question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'render template delete' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'as not unauthenticate user' do

      it "can't deletes the answer" do
        expect{delete :destroy, params: { id: answer, question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirect to sign in page' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATH #update' do
    let!(:answer) { create(:answer, question: question, user: author) }

    context 'with valid attributes' do
      before { login(author) }

      it 'change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: answer.question }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: answer.question }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(author) }

      it 'can not change attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: answer.question }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: answer.question }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #best' do
    let!(:answer) { create(:answer, question: question, user: author) }
    let!(:answer_somebody) { create(:answer, question: question_somebody, user: user) }
    before { login(author) }

    context 'as auhtor of question' do
      it 'can change attribute' do
        patch :best, params: { id: answer, question_id: answer.question }, format: :js
        answer.reload
        expect(answer.best).to eq true
      end

      it 'renders update view' do
        patch :best, params: { id: answer, question_id: answer.question }, format: :js
        expect(response).to render_template :best
      end
    end

    context 'as not auhtor of question' do
      it 'can not change attribute' do
        patch :best, params: { id: answer_somebody, question_id: answer_somebody.question }, format: :js
        answer.reload
        expect(answer.best).to eq false
      end

      it 'renders update view' do
        patch :best, params: { id: answer_somebody, question_id: answer_somebody.question }, format: :js
        expect(response).to render_template :best
      end
    end
  end
end
