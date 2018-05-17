Rails.application.routes.draw do
  get 'collection/new'

  get 'collection/create'

  get 'collection/destroy'

  get 'collection/edit'

  get 'collection/share'

  get 'collection/index'

  get 'welcome/index'

  get "/collections/:id/removenote/:n_id" => "collections#removenote", :as => "removenote_collection"

  get "/collections/:id/addnote/:n_id" => "collections#addnote", :as => "addnote_collection"

  get "logout" => "session#destroy", :as => "logout"
  get "login" => "session#new", :as => "login"
  post "login" => "session#create"
  get "signup" => "users#new", :as => "signup"

  resources :collections
  resources :notes
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "welcome#index"
end
