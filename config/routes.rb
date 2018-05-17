Rails.application.routes.draw do
  get 'friends/index'

  get 'collection/new'

  get 'collection/create'

  get 'collection/destroy'

  get 'collection/edit'

  get 'collection/share'

  get 'collection/index'

  get 'welcome/index'

  get "/collections/:id/removenote/:n_id" => "collections#removenote", :as => "removenote_collection"

  get "/collections/:id/addnote/:n_id" => "collections#addnote", :as => "addnote_collection"

  get "/users/:id/friendrequest/:n_id" => "users#friendrequest", :as => "friendrequest_user"
  get "/users/:id/removefriend/:n_id" => "users#removefriend", :as => "removefriend_user"
  get "/users/:id/acceptrequest/:n_id" => "users#acceptrequest", :as => "acceptrequest_user"
  get "/users/:id/declinerequest/:n_id" => "users#declinerequest", :as => "declinerequest_user"
  get "/users/:id/cancelrequest/:n_id" => "users#cancelrequest", :as => "cancelrequest_user"

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
