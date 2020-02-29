RSpec.shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }

  it '#count_votes' do
    vote = create(:vote, votable: votable, user: user)

    expect(votable.count_votes).to eq(1)
  end
end
