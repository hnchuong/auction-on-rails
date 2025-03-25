FactoryBot.define do
  factory :bid do
    amount { 100 }
    association :auction
    association :buyer, factory: :user
  end
end
