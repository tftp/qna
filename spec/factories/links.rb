FactoryBot.define do
  factory :link do
    sequence (:name) { |n| "MyProject_#{n}" }
    sequence (:url) { |n| "https://myprojects.ru/#{n}" }

    trait :google do
      name { "Google" }
      url { "https://google.ru" }
    end

    trait :yandex do
      name { "Yandex" }
      url { "https://ya.ru" }
    end

    trait :gist do
      name { "Gist" }
      url { "https://gist.github.com/tftp/398dc452ae2212d2e17b60777ee28a3c" }
    end

    trait :invalid do
      name { "Google" }
      url { "https://bad" }
    end

  end
end
