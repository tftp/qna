require 'rails_helper'
RSpec.describe SearchController, type: :controller do
  describe 'GET#index' do
    let(:query) { 'string' }
    let(:model) { 'question' }

    it 'initialize sphinx search' do
      expect(Foundator).to receive(:search).with(query, model)
      get :index, params: {query: query, model: model}
    end

    it 'renders index views' do
      allow(Foundator).to receive(:search).with(query, model).and_return([])
      get :index, params: {query: query, model: model}

      expect(response).to render_template :index
    end
  end
end
