# frozen_string_literal: true
class Note < ActiveRecord::Base
  belongs_to :user, required: true

  validates :title, :body, presence: true

  acts_as_taggable
end
