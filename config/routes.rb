Rails.application.routes.draw do
  # ホーム
  root to: 'home#index'

  # ユーザー認証
  get 'login', to: 'users#login_form'
  post 'login', to: 'users#login'
  get 'logout', to: 'users#logout'

    # config/routes.rb
  get 'posts/select', to: 'posts#select'
  post 'posts/monthselect', to: 'posts#monthselect'
  get 'posts/:year/:month/theaccounting', to: 'posts#theaccounting', as: 'theaccounting'


  # 基本リソース
  resources :users
  resources :companies
  resources :clients do
    collection do
      get :export
    end
  end

  resources :products do
    collection do
      get :export
    end
    resources :product_materials, shallow: true, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :product_stone_parts, shallow: true, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :product_images, shallow: true, only: [:index, :new, :create, :edit, :update, :destroy]
    resource :production, only: [:show, :new, :create, :edit, :update]
  end

  resources :categories

      # 地金マスタ
    resources :materials do
      resources :material_price_histories, shallow: true
      collection do
        get :export
      end
    end

    # 石パーツマスタ
    resources :stone_parts do
      collection do
        get :export
      end
    end

  resources :suppliers
  resources :parts

  # ヘルスチェック
  get "up", to: "rails/health#show", as: :rails_health_check
end
