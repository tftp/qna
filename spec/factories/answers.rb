FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswer#{n}" }
    question { nil }
    user { create(:user) }

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end
  end
end
