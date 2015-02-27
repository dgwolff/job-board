Rails.application.routes.draw do

  get '/posts', to: redirect('/')
  
  resources :posts, :only => [:index]

  root 'posts#index'

  
  match '*path' => redirect('/'), via: :get
end
