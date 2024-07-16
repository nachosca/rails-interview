module Api
  class TodoListsController < ApplicationController
    before_action :set_todo_list, only: [:show]

    # GET /api/todolists
    def index
      @todo_lists = TodoList.all

      respond_to :json
    end

    # GET /api/todolists/{id}
    def show
      render json: @todo_list, include: :todo_items
    end

    private

      def set_todo_list
        @todo_list = TodoList.find(params[:id])
      end
    end
end
