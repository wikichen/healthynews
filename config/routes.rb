Healthynews::Application.routes.draw do

  devise_for :users
  resources :users, :only => [:show]
  resources :posts
  resources :comments
  resources :votes

  # AUTHENTICATION
  devise_scope :user do
    get '/login'    => 'devise/sessions#new'
    get '/register' => 'devise/registrations#new'
    delete '/logout'   => 'devise/sessions#destroy'
  end

  # PAGES
  root to: 'pages#index'
  get '/about' => 'pages#about'
  get '/page/:page' => 'pages#index'
  get '/newest(.format)' => 'home#newest'
  get '/newest/page/:page' => 'home#newest'

  # POSTS
  resources :posts do
    post 'upvote'
    post 'downvote'
    post 'unvote'
  end

  get '/p/:id/(:title)' => 'posts#show'
  get "/p/:id/:title/comments/:comment_short_id" => "posts#show_comment"

  # COMMENTS
  resources :comments do
    post 'upvote'
    post 'downvote'
    post 'unvote'
  end

  post '/comments/post_to/:post_id' => 'comments#create'

  # USERS
  get '/u/:id' => 'users#show'




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
