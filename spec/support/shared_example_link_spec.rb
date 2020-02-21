RSpec.shared_examples "link example" do
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }
end
