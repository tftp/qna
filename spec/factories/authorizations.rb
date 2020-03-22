FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { nil }
    uid { nil }
    confirmation_token { "12345" }
    confirmed_at { Time.current }

    trait 'not_confirmed' do
      confirmed_at { nil }
    end
  end
end
