require 'rails_helper'

RSpec.describe V1::AuthenticationsController, type: :controller do
  describe 'create' do
    let(:user) { Fabricate :user }

    it { should route(:post, '/authenticate').to(action: :create, format: :json) }

    context 'with valid credentials' do
      it do
        post_authentications(email: user.email, password: user.password)

        should respond_with(200)
      end
    end

    context 'with invalid credentials' do
      it do
        post_authentications(email: user.email, password: 'wrond_password')

        should respond_with(401)
      end
    end
  end
end

def post_authentications(credentials)
  request.headers.merge!(accept_header)

  post :create, credentials
end
