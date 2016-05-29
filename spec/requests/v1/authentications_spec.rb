# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  describe 'POST /authenticate' do
    let(:user) { Fabricate :user }

    context 'with valid credentials' do
      before(:each) { post_authenticate(email: user.email, password: user.password) }

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      matches_json_schema('user')
    end

    context 'with invalid credentials' do
      before(:each) { post_authenticate(email: user.email, password: 'wrong_password') }

      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end
      matches_json_schema('errors')

      it 'explains that wrong credentials have been supplied' do
        errors = JSON.parse(response.body, symbolize_names: true)[:errors]
        expect(errors).to match ['You have provided an invalid email or password.']
      end
    end
  end
end

def post_authenticate(credentials)
  post '/authenticate', credentials, accept_header
end
