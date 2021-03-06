# frozen_string_literal: true
class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  private

    attr_reader :current_user

    def authenticate
      authenticate_token || render_unauthorized
    end

    def authenticate_token
      authenticate_with_http_token do |token, _options|
        @current_user = User.find_by(auth_token: token)
      end
    end

    def render_unauthorized
      headers['WWW-Authenticate'] = 'Token realm="Application"'

      render json: {message: 'Bad credentials'}, status: :unauthorized
    end
end
