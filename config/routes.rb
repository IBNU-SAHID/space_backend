Rails.application.routes.draw do
  root "messages#index"

  # Define GET route for fetching messages
  resources :messages, only: [:create, :index] # Add :index to allow GET requests
  mount ActionCable.server => '/cable'

end
