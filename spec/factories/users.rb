# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :name do
    first_name 'Test'
    last_name 'User'
  end
  factory :user do
    association :name, factory: :name, strategy: :build
    sequence(:email) { |n| "user#{n}@swansea.ac.uk" }
    password 'changeme'
    password_confirmation 'changeme'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
    factory :unconfirmed_registered_user, parent: :user do
      after(:build) { |user| user.send_confirmation_instructions }
    end
    factory :admin_user do
      after(:build) { |user| user.add_role(:admin) }
    end
  end
end
