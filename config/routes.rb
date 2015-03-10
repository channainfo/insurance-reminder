Rails.application.routes.draw do
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

      post :notify_call_started
      post :notify_call_finished
    end
  end

  resources :shpas

  get 'settings' => 'settings#index'
  put 'update_settings' => 'settings#update'

  put 'verboice' => 'settings#verboice'
  get 'schedules' => 'settings#schedules'
  get '/steps/manifest' => 'steps#manifest', defaults: { format: :xml }

end
