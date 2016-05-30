# frozen_string_literal: true
module V1
  class UsersController < ApplicationController
    skip_before_action :authenticate

    def create
      user = User.new(user_params)
      if user.save
        render json: user
      else
        render json: {message: 'Validation failed', errors: user.errors.full_messages},
               status: :unprocessable_entity
      end
    end

    private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
  end
end
