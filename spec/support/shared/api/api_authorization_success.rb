RSpec.shared_examples_for 'API Authorizable Successful' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it_behaves_like 'API Check Public Fields'
end
