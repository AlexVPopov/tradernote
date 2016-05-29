class V1::AuthenticationsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render json: user
    else
      render json: {errors: ['You have provided an invalid email or password.']},
             status: :unauthorized
    end
  end
end
