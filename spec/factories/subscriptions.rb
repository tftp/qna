FactoryBot.define do
  factory :subscription do
    user { create(:user) }
    question { create(:question) }
  end
end
