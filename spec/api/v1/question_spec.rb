require 'rails_helper'

RSpec.describe 'Question API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/question/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    context 'unauthorized' do
      it 'returns 401 status if there is not access_token' do
        get "/api/v1/questions/#{question.id}", headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorize' do
      let(:access_token) { create(:access_token, scopes: 'read') }
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }
      let!(:links) { create_list(:link, 2, linkable: question) }
      let(:file_for_attach) { create_file_blob('rails_helper.rb') }

      before do
        question.files.attach(file_for_attach)
        get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.last }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id body commentable_id commentable_type user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { question_response['links'].first }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id name url linkable_id linkable_type created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
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
    context 'unauthorized' do
      it 'returns 401 status if there is not access_token' do
        post "/api/v1/questions", headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorize' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id, scopes: 'write') }
      let(:question_response) { json['question'] }

      context 'with correct data' do
        before { post "/api/v1/questions", params: { access_token: access_token.token, question: { title: 'Title', body: 'Body', links_attributes: [name: 'google', url: 'http://go.com'] } }, headers: headers }

        it 'returns 200 status' do
          expect(response.status).to eq 200
        end

        it 'returns all public fields for question' do
          %w[title body user_id created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
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

    context 'unauthorized' do
      it 'returns 401 status if there is not access_token' do
        patch "/api/v1/questions/#{question.id}", headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        patch "/api/v1/questions/#{question.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorize' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id, scopes: 'write') }
      let(:question_response) { json['question'] }

      context 'with correct data' do
        before { patch "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, question: { id: question.id, title: 'Title', body: 'Body', links_attributes: [name: 'google', url: 'http://go.com'] } }, headers: headers }

        it 'returns 200 status' do
          expect(response.status).to eq 200
        end

        it 'returns all public fields for question' do
          %w[title body user_id created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
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
    let!(:other) { create(:user) }
    let!(:question_other) { create(:question, user: other) }

    context 'unauthorized' do
      it 'returns 401 status if there is not access_token' do
        delete "/api/v1/questions/#{question.id}", headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        delete "/api/v1/questions/#{question.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorize' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id, scopes: 'write') }

      context 'as author of question' do
        it 'delete the question' do
          expect{delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, id: question }, headers: headers }.to change(Question, :count).by(-1)
        end

        it 'returns 204 status' do
          delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, id: question }, headers: headers
          expect(response.status).to eq 204
        end
      end

      context 'as not author of question' do
        it 'can not delete the question' do
          expect{ delete "/api/v1/questions/#{question_other.id}", params: { access_token: access_token.token, id: question_other }, headers: headers }.to_not change(Question, :count)
        end

        it 'returns 403 status' do
          delete "/api/v1/questions/#{question_other.id}", params: { access_token: access_token.token, id: question_other }, headers: headers
          expect(response.status).to eq 403
        end
      end
    end
  end
end
