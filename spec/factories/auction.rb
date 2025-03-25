FactoryBot.define do
  factory :auction do
    title { "Test Auction" }
    start_time { Time.now }
    starting_price { 100 }
    duration { 60 }
    status { "INACTIVE" }
    association :seller, factory: :user
  end
end
