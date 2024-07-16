Rails.application.routes.draw do
  namespace :api do
    resources :todo_lists, only: [:index, :show], path: :todolists do
      resources :todo_items, only: [:create, :update, :destroy], path: :todoitem do
        member do
          put 'complete', to: 'todo_items#complete_item'
        end
      end
    end

  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
