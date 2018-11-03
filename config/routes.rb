Btob::Application.routes.draw do

  match '/categories/bulk_delete' => 'categories#bulk_delete'
  resources :categories

  put '/attachments' => 'attachments#index'
  match '/attachments/bulk_delete' => 'attachments#bulk_delete'
  match '/attachments/bulk_download' => 'attachments#bulk_download'
  resources :attachments do
    get :download
  end

  match '/sent_materials/bulk_delete' => 'sent_materials#bulk_delete'
  resources :sent_materials
  
  put '/media' => 'media#index'
  match '/medias/bulk_delete' => 'media#bulk_delete'
  resources :media

  match '/materials/attach_table_by_category' => 'materials#attach_table_by_category'
  match '/materials/get-files' => 'materials#get_files'
  put '/materials' => 'materials#index'
  match '/materials/my_materials' => 'materials#my_materials'
  match '/materials/add_watcher.json' => 'materials#add_watcher'
  match '/materials/remove_watcher.json' => 'materials#remove_watcher'
  match '/materials/bulk_delete' => 'materials#bulk_delete'
  match '/materials/send_mail' => 'materials#send_mail'
  resources :materials do
    post :attachment_delete
    get :attachment_download
    get :material_to_pdf
    get :download_zip
  end

  match '/media_types/bulk_delete' => 'media_types#bulk_delete'
  resources :media_types

  match '/profile/edit' => 'profiles#edit'
  resources :profiles do
    get :edit
    post :update
  end

  resources :cities

  post '/states/get_cities'
  resources :states

  post '/countries/get_states'
  resources :countries

  put '/users' => 'users#index'
  match '/users/bulk_delete' => 'users#bulk_delete'
  match '/users/password_update' => 'users#password_update', :via => [:post]
  devise_for :users
  resources :users
  
  get "home/index"
  get "home/desktop"
  root to: "home#index" 

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
