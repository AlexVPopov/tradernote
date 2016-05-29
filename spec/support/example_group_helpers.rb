module ExampleGroupHelpers
  def matches_json_schema(schema)
    it 'matches the expected json schema' do
      expect(response).to match_response_schema(schema)
    end
  end
end
