# frozen_string_literal: true
RSpec.shared_examples 'record not found' do
  assert_response_code(404)
  assert_json_schema('not_found')
  assert_message('Record not found')
end
