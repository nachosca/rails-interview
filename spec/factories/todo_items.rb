FactoryBot.define do
  factory :todo_item do
    name { "Test Todo Item" }
    completed { false }
    association :todo_list
  end
end