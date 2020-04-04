RSpec.shared_examples_for 'API Check Public Fields' do
  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(object_response[attr]).to eq object.send(attr).as_json
    end
  end
end
