require 'api_version'

Rails.application.routes.draw do
  scope module: 'v1',
        constraints: APIVersion.new('v1', true),
        defaults: {format: :json} do
    resources :users, only: :create
  end
end
