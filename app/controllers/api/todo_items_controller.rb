module Api
  class TodoItemsController < ApplicationController
    before_action :load_todo_list
    before_action :set_todo_item, only: [:update, :destroy, :complete_item]


    # POST /api/todolists/{todo_list_id}/todoitem
    def create
      @item = @todo_list.todo_items.build(todo_item_params)
      if @item.save
        render json: @item, status: :created
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    # PUT /api/todolists/{todo_list_id}/todoitem/{id}
    def update
      if @item.update(todo_item_params)
        render json: @item
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/todolists/{todo_list_id}/todoitem/{id}
    def destroy
      @item.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end

    # PUT /api/todolists/{todo_list_id}/todoitem/{id}/complete
    def complete_item
      @item.toggle!(:completed)
      if @item.save
        render json: @item
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    private

    def set_todo_item
      @item = @todo_list.todo_items.find(params[:id])
    end

    def todo_item_params
      params.require(:todo_item).permit(:name, :completed)
    end 

    def load_todo_list
      @todo_list = TodoList.find(params[:todo_list_id])
    end
  end
end
