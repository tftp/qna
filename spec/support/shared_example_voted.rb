RSpec.shared_examples_for "voted" do
  describe 'PATCH #voting' do
    context 'as not author of votable' do
      before { login(user) }

      it 'save a new vote for votable' do

        expect{ patch :vote, params: { id: votable, option: 'positive' } }.to change(Vote, :count).by(1)
      end

      it 'cheque of the votables value' do
        patch :vote, params: { id: votable, option: 'positive' }, format: :json

        expect(assigns(:votable).votes.first.value).to eq 1
      end

      it 'as not author votable hav response 200' do
        expect(patch :vote, params: { id: votable, option: 'positive' }, format: :json).to have_http_status(200)
      end
    end

    context 'as author of votable' do
      before { login(author) }

      it 'not save a new vote for votable' do

        expect{patch :vote, params: { id: votable, option: 'positive' }}.to_not change(Vote, :count)
      end

      it 'as author votable hav response 422' do
        expect(patch :vote, params: { id: votable, option: 'positive' }, format: :json).to have_http_status(422)
      end
    end

    context 'as unauthenticate user have not vote'
      it 'not save a new vote for votable' do
        expect{patch :vote, params: { id: votable, option: 'positive' }}.to_not change(Vote, :count)
      end

      it 'responds with error' do
        expect(patch :vote, params: { id: votable, option: 'positive' }, format: :json).to have_http_status(401)
    end
  end
end
