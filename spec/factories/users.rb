FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    profile {Faker::Company.industry}
    occupation {Faker::Company.profession}
    position {Faker::Construction.role}
    email {Faker::Internet.free_email}
    password = Faker::Internet.password(min_length: 6)
    password {password}
    password_confirmation {password}
  end
end