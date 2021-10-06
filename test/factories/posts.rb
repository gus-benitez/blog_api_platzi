FactoryBot.define do
  factory :post do    
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { [false, true].sample }
    association :user
  end
end
