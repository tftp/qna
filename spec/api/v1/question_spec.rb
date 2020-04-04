require 'rails_helper'

RSpec.describe 'Question API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/question/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable Failed' do
      let(:method) { :get }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token, scopes: 'read') }
      let(:question_response) { json['question'] }
      let(:file_for_attach) { create_file_blob('rails_helper.rb') }

      before do
        question.files.attach(file_for_attach)
        get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API Authorizable Successful' do
        let(:object) { question }
        let(:object_response) { question_response }
        let(:public_fields) { %w[title body created_at updated_at] }
      end

      describe 'comments' do
        it_behaves_like 'API Check Public Fields' do
          let(:object) { comments.last }
          let(:object_response) { question_response['comments'].first }
          let(:public_fields) {   %w[id body commentable_id commentable_type user_id created_at updated_at] }
        end

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 2
        end
      end

      describe 'links' do
        it_behaves_like 'API Check Public Fields' do
          let(:object) { links.last }
          let(:object_response) { question_response['links'].first }
          let(:public_fields) {  %w[id name url linkable_id linkable_type created_at updated_at] }
        end

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 2
        end
      end

      describe 'attached files' do
        let(:file) { question.files.last }
        let(:file_response) { question_response['files_url'] }

        it 'returns list of files' do
          expect(file_response.size).to eq 1
        end

        it 'returns url of file' do
          expect(file_response.first['url']).to eq rails_blob_path(file, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable Failed' do
      let(:method) { :post }
    end

    context 'authorize' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id, scopes: 'write') }
      let(:question_response) { json['question'] }

      context 'with correct data' do
        before { post "/api/v1/questions", params: { access_token: access_token.token, question: { title: 'Title', body: 'Body', links_attributes: [name: 'google', url: 'http://go.com'] } }, headers: headers }

        it_behaves_like 'API Authorizable Successful' do
          let(:object) { assigns(:question) }
          let(:object_response) { question_response }
          let(:public_fields) {  %w[title body user_id created_at updated_at] }
        end

        it 'returns all public fields for link of question' do
          %w[id name url linkable_id linkable_type created_at updated_at].each do |attr|
            expect(question_response['links'].first[attr]).to eq assigns(:question).links.first.send(attr).as_json
          end
        end
      end

      context 'with incorrect data' do
        before { post "/api/v1/questions", params: { access_token: access_token.token, question: { title: '', links_attributes: [name: 'google', url: 'http://go.com'] } }, headers: headers }

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable Failed' do
      let(:method) { :patch }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id, scopes: 'write') }
      let(:question_response) { json['question'] }

      context 'with correct data' do
        before { patch "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, question: { id: question.id, title: 'Title', body: 'Body', links_attributes: [name: 'google', url: 'http://go.com'] } }, headers: headers }

        it_behaves_like 'API Authorizable Successful' do
          let(:object) { assigns(:question) }
          let(:object_response) { question_response }
          let(:public_fields) {  %w[title body user_id created_at updated_at] }
        end

        it 'returns all public fields for link of question' do
          %w[id name url linkable_id linkable_type created_at updated_at].each do |attr|
            expect(question_response['links'].first[attr]).to eq assigns(:question).links.first.send(attr).as_json
          end
        end
      end

      context 'with incorrect data' do
        before { patch "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, question: { title: '', links_attributes: [name: 'google', url: 'http://go.com'] } }, headers: headers }

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end

      context 'as not author of question' do
        let(:other) { create(:user) }
        let(:question_other) { create(:question, user: other) }
        before { patch "/api/v1/questions/#{question_other.id}", params: { access_token: access_token.token, question: {id: question_other, title: 'Other', body: 'Other'} }, headers: headers }

        it 'returns 403 status' do
          expect(response.status).to eq 403
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable Failed'

    context 'authorize' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id, scopes: 'write') }
      let(:other) { create(:user) }
      let(:question_other) { create(:question, user: other) }

      it_behaves_like 'API For Destroy' do
        let(:api_path_other) { "/api/v1/questions/#{question_other.id}" }
        let(:object) { question }
        let(:object_other) { question_other }
      end
    end
  end
end
