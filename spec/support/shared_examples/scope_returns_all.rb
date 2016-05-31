# frozen_string_literal: true
RSpec.shared_examples 'scope returns all' do
  it 'returns all records without parameter' do
    expect(query).to match_array(Note.all)
  end
end
