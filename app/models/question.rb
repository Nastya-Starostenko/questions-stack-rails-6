# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :answers, -> { sort_by_best }, dependent: :destroy

  validates :title, :body, presence: true
end
