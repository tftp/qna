require 'rails_helper'

RSpec.describe Foundator, type: :model do

  describe '.search' do
    let(:query) { 'string' }

    it 'initialize sphinx search with correct model' do
      expect(Question).to receive(:search).with(query)
      Foundator.search(query, 'question')
    end

    it 'itialize sphinx search with all models' do
      expect(ThinkingSphinx).to receive(:search).with(query, classes: [Question, Answer, Comment, User])
      Foundator.search(query, 'all')
    end

    it 'unitialize sphinx search with incorrect model' do
      expect(Link).to_not receive(:search).with(query)
      Foundator.search(query, 'link')
    end
  end
end
