# frozen_string_literal: true

Rails.application.routes.draw do
  # root to: "devise/sessions#new"
  # user_root to: "announcements#index"

  devise_for :users, controllers: { registrations: "registrations" }

  devise_scope :user do
    authenticated :user do
      root "announcements#index", as: :root
    end

    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end
  end

  resources :torrents
  resources :announcements
  namespace :admin do
    get "/", to: "dashboard#index", as: "dashboard"
    resources :categories do
      resources :category_metadata_types
    end
    resources :users
    resources :releases do
      resources :release_metadata
    end
    resources :torrents do
      resources :torrent_metadata
    end
    resources :search_fields


    mount RailsSettingsUi::Engine, at: "settings"
  end

  get ":torrent_pass/announce", to: "tracker#announce"
  get ":torrent_pass/scrape", to: "tracker#scrape"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
