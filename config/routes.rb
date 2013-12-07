Ittest::Application.routes.draw do
  resources :options
  resources :questions
  resources :test_details
  resources :test_results
  resources :chapters
  devise_for :users #do
  #  get '/users/sign_out' => 'devise/sessionsd#destroy'
  #end

  get '/users/sign_out' => 'Devise::Sessions#destroy'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get '/create_guest' => "welcome#create_guest", :as => :create_guest_path
  get '/import_questions' => "welcome#import_questions", :as => :import_questions
  post '/importing_questions' => "questions#import", :as => :importing_questions
  match '/test' => 'welcome#test', as: :test
  match '/test_submit' => 'welcome#test_submit', as: :test_submit


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
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
