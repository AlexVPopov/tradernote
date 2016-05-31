# frozen_string_literal: true
class Note < ActiveRecord::Base
  belongs_to :user, required: true

  validates :title, :body, presence: true

  acts_as_taggable

  scope :title_matches, lambda { |query = nil|
    query ? where('title ILIKE :query', query: "%#{query}%") : all
  }

  scope :body_matches, lambda { |query = nil|
    query ? where('body ILIKE :query', query: "%#{query}%") : all
  }

  scope :tag_matches, lambda { |query = nil|
    query ? tagged_with(query, any: true, wild: true) : all
  }

  scope :any_matches, lambda { |query = nil|
    return all if query.blank?
    condition = 'title ILIKE :query OR body ILIKE :query OR tags.name ILIKE :query'
    joins(:tags).where(condition, query: "%#{query}%").distinct
  }
end
