Read::Engine.routes.draw do
  resources :articles

  root :to => "home#index"
  match "*id" => "home#show", :as => "read"
end
