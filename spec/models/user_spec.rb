require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribe_questions).through(:subscriptions) }

  let(:author) { create(:user) }
  let(:somebody) { create(:user) }
  let(:self_question) { create(:question, user: author) }
  let(:somebody_question) { create(:question, user: somebody) }
  let(:self_answer) { create(:answer, question: self_question, user: author) }
  let(:somebody_answer) { create(:answer, question: somebody_question, user: somebody) }

  describe 'is author ' do
    it 'self question' do
        expect(author).to be_is_author(self_question)
    end

    it 'self answer' do
      expect(author).to be_is_author(self_answer)
    end
  end

  describe 'is not author' do
    it 'somebody question' do
      expect(author).not_to be_is_author(somebody_question)
    end

    it 'somebody answer' do
      #можно я это оставлю в качестве примера преобразования?
      #expect(author.is_author?(somebody_answer)).to eq false
      expect(author).not_to be_is_author(somebody_answer)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
