FactoryBot.define do
  factory :bid do
    amount { 150 }
    association :auction
    association :buyer, factory: :user
  end
end
