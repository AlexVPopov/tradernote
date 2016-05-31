# frozen_string_literal: true
module NotesModelSpecHelpers
  def title_matches(query, *results)
    expect(Note.title_matches(query)).to match_array(results)
  end

  def body_matches(query, *results)
    expect(Note.body_matches(query)).to match_array(results)
  end

  def matches(query, *results)
    expect(Note.any_matches(query)).to match_array(results)
  end

  def matches_all(query)
    expect(query).to match_array(Note.all)
  end
end
