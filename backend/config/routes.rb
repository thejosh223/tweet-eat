Backend::Application.routes.draw do
  scope :format => false do

    resource :session, :only => [:show, :update, :destroy]
    resources :errands

    resources :errand_requests
  end
end
