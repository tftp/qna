FactoryBot.define do
  factory :question do
    sequence (:title) { |n| "MyString_#{n}" }
    body { "MyText" }
    user { create(:user) }

    trait :old do
      created_at { Time.now - 2.day }
    end

    trait :invalid do
      title { nil }
    end
  end
end
