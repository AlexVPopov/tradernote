# frozen_string_literal: true
module ExampleHelpers
  def accept_header
    {'Accept' => 'application/vnd.tradernote.v1+json'}
  end

  def authorization_header(token)
    {'Authorization' => "Token token=#{token}"}
  end
end
