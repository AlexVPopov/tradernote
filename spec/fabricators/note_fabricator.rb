# frozen_string_literal: true
Fabricator(:note) do
  user

  title { FFaker::Lorem.phrase }
  body { FFaker::Lorem.paragraph }

  after_build do |note, transients|
    note.user.tag(note, with: FFaker::Lorem.words(rand(1..3)), on: :tags)
  end
end
