# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  resources :paths
  resources :cloud_files
  post "/cloud_files/add", to: "cloud_files#add"
  delete "/cloud_files/delete/:id", to: "cloud_files#delete", as: "cloud_files_delete"
  post "/cloud_files/sync/:id", to: "cloud_files#sync", as: "sync_cloud_files"
  post "/paths/download/:id", to: "paths#download", as: "download_path"
  post "/paths/cancel_download/:id", to: "paths#cancel_download", as: "cancel_download_path"

  root to: "cloud_files#index"

  mount Sidekiq::Web => '/sidekiq'
end
