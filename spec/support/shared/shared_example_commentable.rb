RSpec.shared_examples "Commentable" do
  it { should have_many(:comments).dependent(:destroy) }
end
