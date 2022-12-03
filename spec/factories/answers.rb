# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.sentence }
    association :question
    author { create(:user) }
    best { false }
  end

  trait :invalid do
    body { nil }
  end

  trait :with_attachment do
    after(:build) do |answer|
      answer.files.attach(default_image_params)
    end
  end
end
