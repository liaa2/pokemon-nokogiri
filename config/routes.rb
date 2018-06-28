Rails.application.routes.draw do
  get 'pokemon/index'
  root to: "pokemon#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
