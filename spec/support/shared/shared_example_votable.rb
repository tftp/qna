RSpec.shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let!(:vote) { create(:vote, votable: votable, user: user) }

  it '#rating' do
    expect(votable.rating).to eq(1)
  end
end
