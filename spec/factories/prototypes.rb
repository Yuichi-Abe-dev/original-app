FactoryBot.define do
  factory :prototype do
    title {Faker::App.name}
    catch_copy {Faker::Company.catch_phrase}
    concept {Faker::Job.key_skill}
    association :user
    after(:build) do |prototype|
      prototype.image.attach(io: File.open('public/images/400x400_01.png'), filename: '400x400_01.png')
    end
  end
end