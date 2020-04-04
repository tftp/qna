require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable Failed' do
      let(:method) { :get }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let!(:answers) { create_list(:answer, 2, question: question, user: user) }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorizable Successful' do
        let(:object) { question }
        let(:object_response) { question_response }
        let(:public_fields) { %w[title body created_at updated_at] }
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'contains user object' do
          expect(question_response['user']['id']).to eq question.user.id
      end

      describe 'answers association' do
        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 2
        end

        it_behaves_like 'API Check Public Fields' do
          let(:object) { answers.first }
          let(:object_response) { question_response['answers'].first }
          let(:public_fields) { %w[body user_id created_at updated_at] }
        end
      end
    end
  end
end
