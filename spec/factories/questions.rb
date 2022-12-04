# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { Faker::Lorem.word }
    body { Faker::Lorem.sentence }
    author { create(:user) }

    trait :invalid do
      title { nil }
    end

    trait :with_answers do
      after :create do |question, _evaluator|
        create_list(:answer, 2, question: question)
      end
    end

    trait :with_attachment do
      after(:build) do |question|
        question.files.attach(default_image_params)
      end
    end
  end
end
