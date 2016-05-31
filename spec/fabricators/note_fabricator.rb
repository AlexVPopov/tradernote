# frozen_string_literal: true
Fabricator(:note) do
  transient :user_tags

  user

  title { FFaker::Lorem.phrase }
  body { FFaker::Lorem.paragraph }

  after_build do |note, transients|
    tags = transients[:user_tags] || FFaker::Lorem.words(rand(1..3))
    note.user.tag(note, with: tags, on: :tags)
  end
end
