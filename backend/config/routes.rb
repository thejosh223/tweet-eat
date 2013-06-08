Backend::Application.routes.draw do
  scope :format => false do

    resource :session, :only => [:show, :create, :update, :destroy]
    resources :errands do
      collection do
        get :accepted
      end
      member do
        post :apply
      end
    end

    resources :errand_requests do
      collection do
        get :pending
      end
    end

    resources :ratings
  end
end
