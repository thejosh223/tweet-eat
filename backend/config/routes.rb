Backend::Application.routes.draw do
  root :to => "restaurants#index"
  resources :restaurants do
    collection do
      get 'search'
    end
  end
end
