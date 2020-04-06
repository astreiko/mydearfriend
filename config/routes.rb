Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  get 'users/update', as: 'update_user'
  post 'users/admin', as: 'admin_user'
  post 'users/active', as: 'active_user'
  get 'users/style', as: 'style'
  get 'users/lang', as: 'lang'
  post 'users/:id/groups/upload' =>  'groups#upload'
  delete 'users/destroy', as: 'destroy_users'

  get 'groups/showAll', as: 'user_root'
  patch 'groups/showAll'
  delete "groups/destroy", as: 'destroy_groups'

  get 'items/new', as: 'new_item'
  get 'items/likes', as: 'likes'
  get 'items/showAll', as: 'showAll_item'
  patch 'items/showAll'
  get 'items/showOne', as: 'showOne_item'
  get 'items/show'
  get 'items/index2', as: 'items_index2'
  get 'items/index3', as: 'items_index3'
  get 'items/loadingLikes', as: 'loadingLikes'

  get 'topics/show', as: 'topics_show'

  get 'persons/management', as: 'management'

  devise_for :users, controllers: {omniauth_callbacks: 'omniauth'} # created automatically by device + omniauth

  devise_scope :user do
    match '/sessions/user', to: 'devise/sessions#create', via: :post
  end

  resources :tags
  resources :item_tags
  resources :likes

  resources :users do
     resources :groups
  end

  resources :topics do
     resources :groups
  end

  resources :groups do
     resources :items
  end

  resources :items do
    resources :comments
  end

end
