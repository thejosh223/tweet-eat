Backend::Application.routes.draw do
  scope :format => false do # we only communicate over JSON

  resource :session, :only => [:show, :update, :destroy]
end
