# frozen_string_literal: true
RSpec.shared_examples 'validation failed' do
  assert_response_code(422)
  assert_json_schema('errors')
  assert_message('Validation failed')
end
