Rails.application.routes.draw do
  resources :cloud_files

  root to: "cloud_files#index"
end
