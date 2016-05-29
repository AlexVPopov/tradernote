# frozen_string_literal: true
class UserSerializer < ActiveModel::Serializer
  attributes :email, :auth_token
end
