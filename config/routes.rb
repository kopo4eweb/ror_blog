Rails.application.routes.draw do
  get 'about' =>'page#about'
  get 'contact' => 'page#contact'

  resources :posts
  resources :pictures, only: [:create, :destroy]
  resources :tags, only: [:show]
  root :to => 'posts#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
