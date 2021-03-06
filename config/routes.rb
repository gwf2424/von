Rails.application.routes.draw do

  #get 'store/index'

  #get 'password_resets/new'

  #get 'password_resets/edit'

  #get 'sessions/new'

  post 'sessions/reset' => 'sessions#delete_count'

  patch 'line_items/quantity' => 'line_items#change_quantity'

  match '/line_items/minus_quantity/:id' => 'line_items#minus_quantity', :as => 'minus_quantity', via: :all

  match '/line_items/add_quantity/:id' => 'line_items#add_quantity', :as => 'add_quantity', via: :all

  #resources :line_items do
  #  member do
  #    put 'xction'
  #  end
  #  put 'xction', on: :member
  #end
  #xction_line_item_path(line_item), method: :put

  #post 'line_items/quantity2' => 'line_items#change_quantity'

  resources :users do
    member do
      get :following, :followers
    end
  end
  
  resources :carts
  resources :line_items
  resources :products
  resources :settings, only: [:new, :create, :edit, :update]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  # get 'users/new'

  # get 'static_pages/contact'

  # get 'static_pages/about'

  root 'static_pages#home'

  # get 'static_pages/help'

  get 'store' => 'store#index'

  get 'help' => 'static_pages#help'

  get 'contact' => 'static_pages#contact'

  get 'about' => 'static_pages#about'

  get 'signup' => 'users#new'

  get 'login' => 'sessions#new'

  post 'login' => 'sessions#create'

  delete 'logout' => 'sessions#destroy'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  # 
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

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     #   end
end
