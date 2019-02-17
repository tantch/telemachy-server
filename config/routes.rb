Rails.application.routes.draw do
  devise_for :users,
    path: '',
    path_names: {
     sign_in: 'login',
     sign_out: 'logout',
     registration: 'signup'
    },
    controllers: {
     sessions: 'sessions',
     registrations: 'registrations'
    }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :songs
  get "/spotify", to: "spotify#index"
  get "/spotify/load", to: "spotify#load"
  post "/spotify/play", to: "spotify#play"
    
end
