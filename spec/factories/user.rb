FactoryBot.define do
  factory :user do
    name { "Test User" }
    email_address { Faker::Internet.email }
    password { "password" }
  end
end
