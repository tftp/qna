require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: {question_id: question} }
    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect{post :create, params: { answer: attributes_for(:answer), question_id: question }}.to change(question.answers, :count).by(1)
      end
      it 'redirect to show question view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect{post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }}.to_not change(Answer, :count)
      end
      it 're-render new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template :new
      end
    end
  end
end
