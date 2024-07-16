require 'rails_helper'

RSpec.describe Api::TodoItemsController, type: :controller do
  let(:todo_list) { create(:todo_list) }
  let!(:todo_item) { create(:todo_item, todo_list: todo_list) }
  let(:valid_attributes) { { name: 'Test Todo Item', completed: false } }
  let(:invalid_attributes) { { name: '', completed: false } }

  before do
    request.headers['Content-Type'] = 'application/json'
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new TodoItem" do
        expect {
          post :create, params: { todo_list_id: todo_list.id, todo_item: valid_attributes }
        }.to change(TodoItem, :count).by(1)
      end

      it "renders a JSON response with the new todo_item" do
        post :create, params: { todo_list_id: todo_list.id, todo_item: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to match(/Test Todo Item/)
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the new todo_item" do
        post :create, params: { todo_list_id: todo_list.id, todo_item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) { { name: 'Updated Todo Item', completed: true } }

      it "updates the requested todo_item" do
        put :update, params: { todo_list_id: todo_list.id, id: todo_item.id, todo_item: new_attributes }
        todo_item.reload
        expect(todo_item.name).to eq('Updated Todo Item')
        expect(todo_item.completed).to be_truthy
      end

      it "renders a JSON response with the todo_item" do
        put :update, params: { todo_list_id: todo_list.id, id: todo_item.id, todo_item: new_attributes }
        expect(response).to be_successful
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to match(/Updated Todo Item/)
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the todo_item" do
        put :update, params: { todo_list_id: todo_list.id, id: todo_item.id, todo_item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested todo_item" do
      expect {
        delete :destroy, params: { todo_list_id: todo_list.id, id: todo_item.id }
      }.to change(TodoItem, :count).by(-1)
    end

    it "renders a JSON response with no content" do
      delete :destroy, params: { todo_list_id: todo_list.id, id: todo_item.id }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "PUT #complete_item" do
    it "completes the todo item" do
      put :complete_item, params: { todo_list_id: todo_list.id, id: todo_item.id }
      todo_item.reload
      expect(todo_item.completed).to be_truthy
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it "uncompletes the todo item" do
      todo_item.update(completed: true)
      put :complete_item, params: { todo_list_id: todo_list.id, id: todo_item.id }
      todo_item.reload
      expect(todo_item.completed).to be_falsey
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  def json
    JSON.parse(response.body)
  end
end
