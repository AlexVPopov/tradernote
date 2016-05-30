# frozen_string_literal: true
RSpec.shared_examples 'unauthenticated' do |_request|
  context 'unauthenticated request' do
    assert_response_code(401)
    assert_json_schema('unauthorized')
    assert_message('Bad credentials')
  end
end
