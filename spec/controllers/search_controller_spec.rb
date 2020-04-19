require 'rails_helper'
RSpec.describe SearchController, type: :controller do
  describe 'GET#index' do
    let(:query) { 'string' }

    it 'initialize sphinx search' do
      expect(ThinkingSphinx).to receive(:search).with(query)
      get :index, params: {query: query, model: 'all'}
    end

    it 'renders index views' do
      get :index, params: {query: query, model: 'question'}
      expect(response).to render_template :index
    end
  end
end
