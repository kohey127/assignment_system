Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  devise_for :managers, :controllers => {
    :registrations => 'managers/registrations',
    :sessions => 'managers/sessions'
  }

  devise_scope :manager do
    get "sign_in", :to => "managers/sessions#new"
    get "sign_out", :to => "managers/sessions#destroy"
  end
  
  root 'commits#index'
  resources :commits, except: [:index]
  resources :projects
  resources :employees do
    patch 'status' => 'employees#status_update', as: 'update_status'
  end
end
