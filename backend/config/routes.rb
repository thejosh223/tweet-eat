Backend::Application.routes.draw do
  scope :format => false do

    resource :session, :only => [:show, :create, :update, :destroy]
    resources :errands

    resources :errand_requests

    resources :ratings
  end
end
