# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :cloud_files
  post "/cloud_files/add", to: "cloud_files#add"
  delete "/cloud_files/delete/:id", to: "cloud_files#delete", as: "cloud_files_delete"
  post "/cloud_files/sync/:id", to: "cloud_files#sync", as: "sync_cloud_files"
  post "/cloud_files/cancel_downloads/:id", to: "cloud_files#cancel_downloads", as: "cancel_cloud_file_downloads"
  post "/cloud_files/enqueue_downloads/:id", to: "cloud_files#enqueue_downloads", as: "enqueue_cloud_file_downloads"

  resources :paths
  post "/paths/download/:id", to: "paths#download", as: "download_path"
  post "/paths/cancel_download/:id", to: "paths#cancel_download", as: "cancel_download_path"

  root to: "cloud_files#index"

  mount Sidekiq::Web => '/sidekiq'
end
