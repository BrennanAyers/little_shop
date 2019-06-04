FactoryBot.define do
  factory :address do
    address { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip { "MyString" }
    user { nil }
  end
end
