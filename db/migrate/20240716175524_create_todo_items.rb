class CreateTodoItems < ActiveRecord::Migration[7.0]
  def change
    create_table :todo_items do |t|
      t.string :name
      t.belongs_to :todo_list
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
