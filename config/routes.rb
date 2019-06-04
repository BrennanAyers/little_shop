Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :items, only: [:index, :show]

  get '/carts', to: 'carts#show'
  post '/carts', to: 'carts#add'
  patch '/carts', to: 'carts#update'
  delete '/carts', to: 'carts#clear'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#logout'

  get '/profile', to: 'default/users#show'
  get '/profile/edit', to: 'default/users#edit'
  patch '/profile/edit', to: 'default/users#update'
  scope module: :default, path: :profile do
    resources :orders, only: [:create, :show, :index, :destroy], as: :profile_orders
  end

  resources :addresses, only: [:new, :create, :edit, :update, :destroy]

  get '/merchants', to: 'merchants#index'

  patch 'merchants/items/enable/:id', to: 'merchants/items#enable'
  patch 'merchants/items/disable/:id', to: 'merchants/items#disable'

  get '/dashboard', to: 'merchants/orders#index'
  scope module: 'merchants', path: 'dashboard', as: :dashboard do
    resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :order_items, only: [:update]
    resources :orders, only: [:show]
  end

  namespace :admin do
    resources :users, only: [:index, :show]
    get '/dashboard', to: 'users#dashboard'
    get '/merchants/:id', to: 'merchants#show', as: :merchant
    patch '/merchant/edit', to: 'merchants#edit'
    patch '/merchant/enable/:id', to: 'merchants#enable'
    patch '/merchant/disable/:id', to: 'merchants#disable'
    resources :orders, only: [:update]
  end
end
