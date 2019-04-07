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
  resources :tasks do
    resources :task_events, only: [:index, :create]
  end
  get "/me", to: "user#me"
  get "/spotify", to: "spotify#index"
  get "/spotify/load", to: "spotify#load"
  post "/spotify/create_playlist", to: "spotify#create_playlist"
  post "/spotify/play", to: "spotify#play"
  get "/spotify/currently_playing",to: "spotify#fetchCurrentlyPlaying"
    
end
