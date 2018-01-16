# frozen_string_literal: true

Rails.application.routes.draw do
  # root to: "devise/sessions#new"
  # user_root to: "announcements#index"

  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :torrents

  resources :announcements

  devise_scope :user do
    authenticated :user do
      root "announcements#index", as: :root
      # get "torrents", as: :torrents
      namespace :admin do
        get "/", to: "dashboard#index", as: "dashboard"
        resources :categories
        resources :users
        resources :releases
        resources :torrents

        mount RailsSettingsUi::Engine, at: "settings"
      end
    end

    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end
  end

  get ":torrent_pass/announce", to: "tracker#announce"
  get ":torrent_pass/scrape", to: "tracker#scrape"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
