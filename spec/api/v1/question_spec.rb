require 'rails_helper'

RSpec.describe 'Question API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

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
      let(:access_token) { create(:access_token) }
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
end
