Backend::Application.routes.draw do
  root :to => 'restaurants#index'
  resources :restaurants, :only => [:show, :index, :create] do
    collection do
      get 'search'
      get 'map'
    end
    member do
      post 'make_comment'
    end
  end
end
