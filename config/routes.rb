Rails.application.routes.draw do
  namespace :vehicles do
    get 'plains/index'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
