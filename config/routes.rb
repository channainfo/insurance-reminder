Rails.application.routes.draw do
  resources :operational_districts do
    member do 
      put 'update_settings'
    end

    collection do 
      post 'update_status'
    end
  end


  root 'calls#index'

  get 'search' => 'calls#index'

  get 'sign_in' => 'sessions#new'
  delete 'sign_out' => 'sessions#destroy'

  resources :sessions, only: [:index, :create, :destroy]

  resources :users do
    get :profile, on: :collection
    put :change_password, on: :collection
    get :reset_password, on: :member
  end

  resources :organizations

  resources :call_logs, only: [:index]
  resources :calls, only: [:index, :new, :create] do
    member do
      put 'retry'
    end

    collection do
      get 'download_csv'

      post :notify_call_started
      post :notify_call_finished
    end
  end

  get 'calls/:phone_number' => 'calls#show'
  post 'calls/update_status' => 'calls#update_status'

  resources :settings, only: [:index]
  put 'update_settings' => 'settings#update_settings'

  put 'verboice' => 'settings#verboice'
  get 'schedules' => 'settings#schedules'
  get '/steps/manifest' => 'steps#manifest', defaults: { format: :xml }

end
