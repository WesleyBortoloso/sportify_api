Rails.application.routes.draw do
  devise_for :users

  mount Base => '/api'
end
