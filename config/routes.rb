Read::Engine.routes.draw do
  resources :articles
  #get "profil/:id" => "profile#show"
  #get "profil/:id" => "profile#show"
  match "profil/*id" => "profile#show", :as => "profile", :format => "html"

  root :to => "home#index"
  match "*id" => "home#show", :as => "read"

end
