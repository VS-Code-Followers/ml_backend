Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }, defaults: { format: :json }

  namespace :api do
    namespace :v1 do
      # resources :books, only: %i[create destroy]
      # get '/users/current', to: 'users#current', as: 'current'
    end
  end

  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
