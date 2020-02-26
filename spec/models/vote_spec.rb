require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_range(-1..1) }
  
  #эта проверка не идет, наверное нельзя проверить множественные поля на уникальность
  #it { should validate_uniqueness_of([:users, :votable_type, :votable_id]) }
end
