Rails.application.routes.draw do
  get '/' => 'page#index'
  get 'about' =>'page#about'
  get 'contact' => 'page#contact'

  root :to => 'page#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
