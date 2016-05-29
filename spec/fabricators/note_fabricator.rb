# frozen_string_literal: true
Fabricator(:note) do
  user

  title { FFaker::Lorem.phrase }
  body { FFaker::Lorem.paragraph }
end
