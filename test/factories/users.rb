FactoryBot.define do
  factory :user do
    id { Faker::Number.number(digits: 10) }
    email { Faker::Internet.email }
    name { Faker::Name.name }
  end
end
