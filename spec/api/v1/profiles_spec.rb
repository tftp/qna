require 'rails_helper'

RSpec.describe 'Profile API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }
  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable Failed' do
      let(:method) { :get }
    end

    context 'authorize' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:object) { user }
      let(:object_response) { json['user'] }
      let(:public_fields) { %w[id email admin created_at updated_at] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorizable Successful'
      it_behaves_like 'API Check Private Fields'
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable Failed' do
      let(:method) { :get }
    end

    context 'authorize' do
      let!(:users) { create_list(:user, 2) }
      let!(:user) { users.first }
      let(:access_token) { create(:access_token) }
      let(:object) { user }
      let(:object_response) { json['users'].first }
      let(:public_fields) { %w[id admin email created_at updated_at] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorizable Successful'
      it_behaves_like 'API Check Private Fields'

      it "returns list of" do
        expect(json['users'].size).to eq 2
      end
    end
  end
end
