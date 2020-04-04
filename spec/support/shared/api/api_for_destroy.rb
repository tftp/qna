RSpec.shared_examples_for 'API For Destroy' do
  context 'as author of question' do
    it 'delete the question' do
      expect{do_request(method, api_path, params: { access_token: access_token.token, id: object }, headers: headers) }.to change(object.class, :count).by(-1)
    end

    it 'returns 204 status' do
      do_request(method, api_path, params: { access_token: access_token.token, id: object }, headers: headers)
      expect(response.status).to eq 204
    end
  end

  context 'as not author of question' do
    it 'can not delete the question' do
      expect{ do_request(method, api_path_other, params: { access_token: access_token.token, id: object_other }, headers: headers) }.to_not change(object_other.class, :count)
    end

    it 'returns 403 status' do
      do_request(method, api_path_other, params: { access_token: access_token.token, id: object_other }, headers: headers)
      expect(response.status).to eq 403
    end
  end
end
