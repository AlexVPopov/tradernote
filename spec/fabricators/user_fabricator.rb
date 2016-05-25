Fabricator(:user) do
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password '123456'
  password_confirmation '123456'
end
