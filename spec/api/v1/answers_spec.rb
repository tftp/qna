require 'rails_helper'

RSpec.describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable Failed' do
      let(:method) { :get }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question, user: user) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { question_id: question.id, access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorizable Successful' do
        let(:object) { answer }
        let(:object_response) { json['answers'].first }
        let(:public_fields) { %w[id body created_at updated_at user_id] }
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end
    end
  end
end
