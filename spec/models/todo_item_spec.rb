require 'rails_helper'

RSpec.describe TodoItem, type: :model do
  let(:todo_list) { create(:todo_list) }
  let(:todo_item) { build(:todo_item, todo_list: todo_list) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(todo_item).to be_valid
    end

    it "is not valid without a name" do
      todo_item.name = nil
      expect(todo_item).to_not be_valid
    end

    it "is not valid with a blank name" do
      todo_item.name = ''
      expect(todo_item).to_not be_valid
    end
  end

  describe "associations" do
    it "belongs to a todo_list" do
      association = TodoItem.reflect_on_association(:todo_list)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "completing the todo item" do
    it "toggles completed status" do
      todo_item.completed = false
      todo_item.save!
      expect(todo_item.completed).to be_falsey
      
      todo_item.toggle!(:completed)
      expect(todo_item.completed).to be_truthy
      
      todo_item.toggle!(:completed)
      expect(todo_item.completed).to be_falsey
    end
  end
end