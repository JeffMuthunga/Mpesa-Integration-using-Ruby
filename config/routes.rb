Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "generate_access_token", to: 'mpesa#generate_access_token'
  post "send_stk_push", to: 'mpesa#send_stk_push'

  # Defines the root path route ("/")
  # root "articles#index"
end
