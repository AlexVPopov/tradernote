# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  describe 'POST /authenticate' do
    let(:user) { Fabricate :user }

    context 'with valid credentials' do
      before(:each) { post_authenticate(email: user.email, password: user.password) }

      assert_response_code(200)

      assert_json_schema('user')
    end

    context 'with invalid credentials' do
      before(:each) { post_authenticate(email: user.email, password: 'wrong_password') }

      assert_response_code(401)

      assert_json_schema('unauthorized')

      it 'responds with correct message' do
        message = extract(response, :message)
        expect(message).to eq 'Bad credentials'
      end
    end
  end
end

def post_authenticate(credentials)
  post '/authenticate', credentials, accept_header
end
