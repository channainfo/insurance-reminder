Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'calls#index'

  get 'search' => 'calls#index'

  get 'sign_in' => 'sessions#new'
  delete 'sign_out' => 'sessions#destroy'

  resources :sessions, only: [:index, :create, :destroy]

  resources :users

  resources :call_logs, only: [:index]
  resources :calls, only: [:index, :new, :create] do
    member do
      put 'retry'
    end

    collection do
      get 'download_csv'
    end
  end

  resources :shpas

  get 'settings' => 'settings#index'
  put 'update_settings' => 'settings#update'

  get '/steps/manifest' => 'steps#manifest', defaults: { format: :xml }
  post '/steps/notify_call_failed' => 'steps#notify_call_failed'
  post '/steps/notify_call_success' => 'steps#notify_call_success'

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
  #     resources :products
  #   end
end
