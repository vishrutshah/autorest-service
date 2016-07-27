Rails.application.routes.draw do
  get 'validate/index'
  post 'validate/swagger'

  root 'welcome#index'

  get 'generate/client'
  post 'generate/create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
