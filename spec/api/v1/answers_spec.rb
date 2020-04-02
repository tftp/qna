require 'rails_helper'

RSpec.describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 2, question: question, user: user) }

    context 'unauthorized' do
      it 'returns 401 status if there is not access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { question_id: question.id }, headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { question_id: question.id, access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { question_id: question.id, access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at user_id].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end
end
