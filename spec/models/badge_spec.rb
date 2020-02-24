require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to(:badgeable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :file }

  it 'have attached file' do
    expect(Badge.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
