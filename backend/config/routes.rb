Backend::Application.routes.draw do
  scope :format => false do

    resource :session, :only => [:show, :create, :update, :destroy]
    resources :errands do
      collection do
        get :accepted
        get :mine
      end
      member do
        post :apply
        put :cancel
        put :acknowledge
      end
    end

    resources :users do
      member do
        get :ratings
        get :errands
        get :requests
      end
    end

    resources :errand_requests do
      collection do
        get :pending
      end
      member do
        put :decline
        put :undodecline
        put :reject
        put :finish
      end
    end

    resources :ratings
  end
end
