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
end
