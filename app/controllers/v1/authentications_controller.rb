# frozen_string_literal: true
module V1
  class AuthenticationsController < ApplicationController
    skip_before_action :authenticate

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        render json: user
      else
        render json: {message: 'Bad credentials'}, status: :unauthorized
      end
    end
  end
end
