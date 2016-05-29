# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  describe 'create' do
    it do
      params = {user: Fabricate.attributes_for(:user)}
      permitted_params = %i(email password password_confirmation)
      should permit(*permitted_params).for(:create, params: params).on(:user)
    end

    it { should route(:post, '/users').to(action: :create, format: :json) }

    context 'with valid parameters' do
      let(:user_attributes) { Fabricate.attributes_for(:user) }

      it 'saves a new user to the database' do
        expect { post_create(user_attributes) }.to change(User, :count).by(1)
      end

      it do
        post_create(user_attributes)

        should respond_with(200)
      end
    end

    context 'with invalid parameters' do
      let(:user_attributes) { Fabricate.attributes_for(:user, email: nil) }

      it 'does not save a new user to the database' do
        expect { post_create(user_attributes) }.not_to change(User, :count)
      end

      it do
        post_create(user_attributes)

        should respond_with(422)
      end
    end
  end
end

def post_create(params)
  request.headers.merge!(accept_header)

  post :create, user: params
end
