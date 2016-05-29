# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /users' do
    context 'with valid parameters' do
      let(:user_attributes) { Fabricate.attributes_for(:user) }

      before(:each) { post_users(user_attributes) }

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      matches_json_schema('user')

      it 'returns a user with correct attributes' do
        user = JSON.parse(response.body, symbolize_names: true)[:user]
        expect(user[:email]).to eq(user_attributes[:email])
      end
    end

    context 'with invalid parameters' do
      let(:user_attributes) { Fabricate.attributes_for(:user, email: nil) }

      before(:each) do |example|
        post_users(user_attributes) unless example.metadata[:skip_before]
      end

      it 'responds with 422' do
        expect(response).to have_http_status(422)
      end

      it 'matches the expected schema' do
        expect(response).to match_response_schema('errors')
      end

      it 'returns the validation errors', skip_before: true do
        user = Fabricate.build(:user, user_attributes)
        user.valid?
        post_users(user_attributes)

        expect(JSON.parse(response.body)['errors']).to match(user.errors.full_messages)
      end
    end
  end
end

def post_users(params)
  post '/users', {user: params}, accept_header
end
