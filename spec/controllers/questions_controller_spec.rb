require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    it 'populates an array of all questions' do
      questions = create_list(:question, 3)

      get :index

      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index views' do
      get :index

      expect(response).to render_template :index
    end
  end
end
