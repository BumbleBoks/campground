Campground::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  get 'invite_user', to: 'users#invite_user', as: 'invite_user'
  resources :users, constraints: { id: /[A-Za-z\d_]+/ }
  
  resources :sessions, only: :create
  
  root 'static_pages#home'
  get '/about' => 'static_pages#about'
  get '/contact' => 'static_pages#contact'
  
  get 'login', to: 'sessions#new', as: 'login'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
  
  namespace :common do
    resources :trails do
      # get 'search/:name', to: 'trails#search', on: :collection, as: 'search',
      #   constraints: { name: /[A-Za-z\d_]+(%|\w)*/ }
      get 'search/:name', to: 'trails#search', on: :collection, as: 'search'
    end
    resources :missing_trails, except: [:new, :show]
  end
  
  namespace :community do
    resources :updates, only: [:create]
    resources :trades, except: [:edit]
  end

  get 'favorites/show', to: 'corner/favorites#show', as: 'favorites/show'
  get 'favorites/new', to: 'corner/favorites#new', as: 'favorites/new'
  namespace :corner do
    resources :favorites, only: [:create] 
    post 'favorites/add_trail'
    post 'favorites/remove_trail' 
    post 'favorites/add_star'
    post 'favorites/remove_star'
    
    get "/logs/:year/:month/:day", to: 'logs#show', as: 'logs', constraints: {
      year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/       
    }  
    # resources :logs, only: [:new, :create, :destroy]       
    resources :logs, only: [:destroy]       
  end
  
  # edit and update path for corner::logs
  get "/corner/logs/:year/:month/:day/edit", to: 'corner/logs#edit', as: 'edit_corner_log', constraints: {
    year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/       
  }
  post "/corner/logs/:year/:month/:day", to: 'corner/logs#update', constraints: {
    year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/       
  }
  patch "/corner/logs/:year/:month/:day", to: 'corner/logs#update', constraints: {
    year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/       
  }
  

  get "site/user_requests/:token", to: 'site/user_requests#edit_request', as: "/edit_site_user_request/"
  post "site/user_requests/:token", to: 'site/user_requests#process_request'
  namespace :site do
    resources :user_requests, only: [:create]
  end  
  
  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
