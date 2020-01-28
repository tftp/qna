require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:question_old) { question }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: author) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index views' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    context 'as not authenticate user' do
      before { login(author) }
      before { get :new }

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'as not unauthenticate user' do
      before { get :new }

      it "redirect to sign in page" do
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe 'GET #edit' do
    context 'as authenticate user' do
      before { login(author) }
      before { get :edit, params: { id: question } }

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'as not authenticate user' do
      before { get :edit, params: { id: question } }

      it 'redirect to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(author) }

      it 'saves a new question in the database' do
        expect{post :create, params: { question: attributes_for(:question), user_id: author }}.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question), user_id: author }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      before { login(author) }

      it 'does not save the question' do
        expect{post :create, params: { question: attributes_for(:question, :invalid), user_id: author }}.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid), user_id: author }
        expect(response).to render_template :new
      end
    end

    context 'as unauthenticate user' do
      it 'does not create the question' do
        expect{post :create, params: { question: attributes_for(:question), user_id: author }}.to_not change(Question, :count)
      end

      it 'redirect to sign in page' do
        post :create, params: { question: attributes_for(:question), user_id: author }
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { login(user) }

      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect { assigns(:question).to eq question }
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'} }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirect to update question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes'do
      before { login(user) }
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not change question' do
        question.reload
        expect(question.title).to eq question_old.title
        expect(question.body).to eq question_old.body
      end

      it 'render edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'as unauthenticate user'do

      it 'not assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect { assigns(:question).to_not eq question }
      end

      it 'does not change question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'} }
        question.reload
        expect(question.title).to eq question_old.title
        expect(question.body).to eq question_old.body
      end

      it 'redirect to sign in page' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'} }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: author) }

    context 'as author' do
      before { login(author) }

      it 'deletes the question' do
        expect{delete :destroy, params: { id: question }}.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'as not author' do
      before { login(user) }

      it "can't deletes the question" do
        expect{delete :destroy, params: { id: question }}.to_not change(Question, :count)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'as not authenticate user' do

      it "can't deletes the question" do
        expect{delete :destroy, params: { id: question }}.to_not change(Question, :count)
      end

      it 'redirect to sign in page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end

  end
end
