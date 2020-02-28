RSpec.shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it '#count_votes' do
    votable = create(model.to_s.underscore.to_sym, user: user) if model.eql? Question
    votable = create(model.to_s.underscore.to_sym, question: question, user: user) if model.eql? Answer

    vote = create(:vote, votable: votable, user: user)
    expect(votable.count_votes).to eq(1)
  end
end
