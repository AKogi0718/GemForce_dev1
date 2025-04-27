Rails.application.routes.draw do

    # ホーム
    root to: 'home#index'

    # ユーザー認証
    get 'login' => 'users#login_form'
    post 'login' => 'users#login'
    get 'logout' => 'users#logout'

    # ユーザー管理
    get 'users/index' => 'users#index'
    get 'users/new' => 'users#new'
    post 'users/create' => 'users#create'
    get 'users/:id' => 'users#show'
    get 'users/:id/edit' => 'users#edit'
    post 'users/:id/update' => 'users#update'

    # 会社管理
    get 'companies' => 'companies#index'
    get 'companies/new' => 'companies#new'
    post 'companies/create' => 'companies#create'
    get 'companies/:id' => 'companies#show'
    get 'companies/:id/edit' => 'companies#edit'
    post 'companies/:id/update' => 'companies#update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
