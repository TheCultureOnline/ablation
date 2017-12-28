Rails.application.routes.draw do
  namespace :admin do
    get '/', to: 'dashboard#index', as: 'dashboard'
    resources :users
  end

  resources :announcements
  # root to: "devise/sessions#new"
  # user_root to: "announcements#index"

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'announcements#index', as: :root
      # get "torrents", as: :torrents

      namespace :admin do
        resources :users

        mount RailsSettingsUi::Engine, at: 'settings'
      end
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
