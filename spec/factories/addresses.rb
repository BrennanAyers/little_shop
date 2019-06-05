FactoryBot.define do
  factory :address do
    address { "1234 Test Rd." }
    city { "Denver" }
    state { "CO" }
    zip { "80123" }
    user { nil }
  end
end
