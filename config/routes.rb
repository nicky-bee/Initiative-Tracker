Rails.application.routes.draw do
  resources :creatures do
    collection do
      delete :clear_encounters
      post :import_encounter
      get :export_encounter
    end
  end
  post 'creatures/roll_initiatives', to: 'creatures#roll_initiatives', as: 'roll_initiatives'
  root 'creatures#index'
end
