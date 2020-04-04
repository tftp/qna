RSpec.shared_examples_for 'API Check Private Fields' do
  let(:private_fields) { %w[password encrypted_password] }

  it 'does not returns private fields' do
    private_fields.each do |attr|
      expect(json).to_not have_key(attr)
    end
  end
end
