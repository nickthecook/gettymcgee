# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  resources :paths
  resources :cloud_files

  root to: "cloud_files#index"

  mount Sidekiq::Web => '/sidekiq'
end
