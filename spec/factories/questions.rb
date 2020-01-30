FactoryBot.define do
  factory :question do
    sequence (:title) { |n| "MyString_#{n}" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
