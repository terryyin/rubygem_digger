Rails.application.routes.draw do
  resources :working_items do
    collection do
      post :apply_job
      post :submit_job
    end
  end
  get 'regenerate' => 'working_items#regenerate'
  get 'download/*id' => 'working_items#download'
  root 'working_items#index'
end
