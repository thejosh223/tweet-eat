Backend::Application.routes.draw do
  resources :restaurants do
    collection do
      get 'search'
    end
  end
  root to: "restaurants#index"
end
