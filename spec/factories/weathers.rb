# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :weather do
    data ""
    description "MyText"
    temperature 1.5
    speed 1.5
  end
end
