# frozen_string_literal: true
class NoteSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :tags, :user_id, :created_at, :updated_at

  def tags
    object.tags_from(object.user)
  end
end
