# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /users' do
    context 'with valid parameters' do
      let(:user_params) { Fabricate.attributes_for(:user) }

      before(:each) { post_users(user_params) }

      assert_response_code(200)

      assert_json_schema('user')

      it 'returns a user with correct attributes' do
        user = JSON.parse(response.body, symbolize_names: true)[:user]
        expect(user[:email]).to eq(user_params[:email])
      end
    end

    context 'with invalid parameters' do
      let(:user_params) { Fabricate.attributes_for(:user, email: nil) }

      before(:each) do |example|
        post_users(user_params) unless example.metadata[:skip_before]
      end

      assert_response_code(422)

      assert_json_schema('errors')

      it 'returns the validation errors', skip_before: true do
        user = Fabricate.build(:user, user_params)
        user.valid?
        post_users(user_params)

        expect(JSON.parse(response.body)['errors']).to match(user.errors.full_messages)
      end
    end
  end
end

def post_users(params)
  post '/users', {user: params}, accept_header
end
