RSpec.shared_examples_for "voted" do
  describe 'PATCH #voting' do
    context 'as authenticate user' do
      before { login(author) }

      it 'assigns a new vote for votable' do
        patch :vote, params: { id: votable, option: 'positive' }, format: :json

        expect(assigns(:votable).votes.first).to be_a_new(Vote)
        expect(assigns(:votable).votes.first.value).to eq 1
      end

      it 'cheque of the votables value' do
        patch :vote, params: { id: votable, option: 'positive' }, format: :json

        expect(assigns(:votable).votes.first.value).to eq 1
      end

      it 'as author votable hav response 422' do
        expect(patch :vote, params: { id: votable, option: 'positive' }, format: :json).to have_http_status(422)
      end

      it 'as not author votable hav response 200' do
        expect(patch :vote, params: { id: votable_user, option: 'positive' }, format: :json).to have_http_status(200)
      end
    end

    context 'as unauthenticate user hav response 401'
      it 'responds with error' do
        expect(patch :vote, params: { id: votable, option: 'positive' }, format: :json).to have_http_status(401)
    end
  end
end
