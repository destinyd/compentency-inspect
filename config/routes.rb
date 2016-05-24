Rails.application.routes.draw do
  devise_for :users, :skip => :all
  devise_scope :user do
    get    "/admin/sign_in"  => "admin/sessions#new"
    post   "/admin/sign_in"  => "admin/sessions#create"
    delete "/admin/sign_out" => "admin/sessions#destroy"
  end

  devise_scope :user do
    get    "/sign_in"  => "sessions#new"
    post   "/sign_in"  => "sessions#create"
    delete "/sign_out" => "sessions#destroy"
  end

  namespace :admin do
    get "/dashboard", to: "dashboard#index"
  end

  get  "/test_status",       to: "test_status#index"
  post "/test_status/start", to: "test_status#start"

  get  "/test_wares/data",   to: "test_wares#data"

  get  "/test_wares",   to: "test_wares#index"
end
