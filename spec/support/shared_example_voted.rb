RSpec.shared_examples_for "voted" do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }
  let!(:votable) { (model.eql? QuestionsController) ? question : answer }
  let!(:question_user) { create(:question, user: user) }
  let!(:answer_user) { create(:answer, question: question, user: user) }
  let!(:votable_user) { (model.eql? QuestionsController) ? question_user : answer_user }

  describe 'PATCH #voting' do

    context 'as authenticate user' do
      before { login(author) }

      it 'as author votable hav response 422' do
        expect(patch :voting, params: { id: votable, option: 'positive' }, format: :json).to have_http_status(422)
      end

      it 'as not author votable hav response 200' do
        expect(patch :voting, params: { id: votable_user, option: 'positive' }, format: :json).to have_http_status(200)
      end
    end

    context 'as unauthenticate user hav response 401'
      it 'responds with error' do
        expect(patch :voting, params: { id: votable, option: 'positive' }, format: :json).to have_http_status(401)
    end
  end
end
