require 'rails_helper'

RSpec.describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable Failed' do
      let(:method) { :get }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 2, commentable: answer, user: user) }
      let!(:links) { create_list(:link, 2, linkable: answer) }
      let(:file_for_attach) { create_file_blob('rails_helper.rb') }

      before do
        answer.files.attach(file_for_attach)
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { id: answer.id, question_id: question.id, access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API Authorizable Successful' do
        let(:object) { answer }
        let(:object_response) { answer_response }
        let(:public_fields) { %w[id body created_at updated_at user_id] }
      end

      describe 'comments' do
        let(:comment) { comments.last }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id body commentable_id commentable_type user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { answer_response['links'].first }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id name url linkable_id linkable_type created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'attached files' do
        let(:file) { answer.files.last }
        let(:file_response) { answer_response['files_url'] }

        it 'returns list of files' do
          expect(file_response.size).to eq 1
        end

        it 'returns url of file' do
          expect(file_response.first['url']).to eq rails_blob_path(file, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable Failed' do
      let(:method) { :post }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id, scopes: 'write') }
      let(:answer_response) { json['answer'] }

      context 'with correct data' do
        before { post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, question_id: question, answer: { body: 'Body', links_attributes: [name: 'google', url: 'http://go.com'] } }, headers: headers }

        it_behaves_like 'API Authorizable Successful' do
          let(:object) { assigns(:answer) }
          let(:object_response) { answer_response }
          let(:public_fields) { %w[body user_id created_at updated_at] }
        end

        it 'returns all public fields for link of answer' do
          %w[id name url linkable_id linkable_type created_at updated_at].each do |attr|
            expect(answer_response['links'].first[attr]).to eq assigns(:answer).links.first.send(attr).as_json
          end
        end
      end

      context 'with incorrect data' do
        before { post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, question_id: question, answer: { body: '', links_attributes: [name: 'google', url: 'http://go.com'] } }, headers: headers }

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:question_id/answers/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable Failed' do
      let(:method) { :patch }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id, scopes: 'write') }
      let(:answer_response) { json['answer'] }

      context 'with correct data' do
        before { patch "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { access_token: access_token.token, answer: { id: answer.id, body: 'Body', links_attributes: [name: 'google', url: 'http://go.com'] } }, headers: headers }

        it_behaves_like 'API Authorizable Successful' do
          let(:object) { assigns(:answer) }
          let(:object_response) { answer_response }
          let(:public_fields) { %w[body user_id created_at updated_at] }
        end

        it 'returns all public fields for link of answer' do
          %w[id name url linkable_id linkable_type created_at updated_at].each do |attr|
            expect(answer_response['links'].first[attr]).to eq assigns(:answer).links.first.send(attr).as_json
          end
        end
      end

      context 'with incorrect data' do
        before { patch "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { access_token: access_token.token, answer: { id: answer.id, body: '', links_attributes: [name: 'google', url: 'http://go.com'] } }, headers: headers }

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end

      context 'as not author of question' do
        let(:other) { create(:user) }
        let(:answer_other) { create(:answer, question: question, user: other) }
        before { patch "/api/v1/questions/#{question.id}/answers/#{answer_other.id}", params: { access_token: access_token.token, answer: { id: answer_other, body: 'Other' } }, headers: headers }

        it 'returns 403 status' do
          expect(response.status).to eq 403
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:question_id/answers/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable Failed'

    context 'authorize' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id, scopes: 'write') }
      let(:other) { create(:user) }
      let(:answer_other) { create(:answer, question: question, user: other) }

      it_behaves_like 'API For Destroy' do
        let(:api_path_other) { "/api/v1/questions/#{question.id}/answers/#{answer_other.id}" }
        let(:object) { answer }
        let(:object_other) { answer_other }
      end

    end
  end
end
