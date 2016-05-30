# frozen_string_literal: true
module ExampleGroupHelpers
  def assert_json_schema(schema)
    it 'matches the expected json schema' do
      expect(response).to match_response_schema(schema)
    end
  end

  def assert_response_code(code)
    it "responds with #{code}" do
      expect(response).to have_http_status(code)
    end
  end

  def assert_message(message)
    it 'returns the correct message' do
      expect(JSON.parse(response.body)['message']).to eq(message)
    end
  end
end
