FactoryBot.define do
  factory :user do
    password_digest { "password" }
    role { 0 }
    active { true }

    sequence :name do |n|
      "User #{n}"
    end

    sequence :email do |n|
      "person#{n}@example.com"
    end
  end
end
