#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
Musicloud::Application.routes.draw do


  get 'tag/cloud',        to: 'tag#cloud',         as: :trends  
  get 'tag/search/:id',        to: 'tag#search',         as: :showtag  


  resources :audios
  
  resources :unlikes

  resources :likes

  resources :comments

resources :friendships do
  member do
    post 'friend_request'
    put 'friend_request_accept'
    delete 'friend_request_reject'
  end
end

resources :musics

  get "sessions/new"

  controller :sessions do
    get  'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  controller :musics do
    get  'home' => :index
  end

  controller :users do
    get 'register' => :new
    post 'profile' => :show
    get 'search' => :index
    get 'contact' => :contact
  end

  get "sessions/create"
  get "sessions/destroy"
  resources :users

  get 'users/friends/:id',        to: 'users#friends',         as: :friends
  get 'users/mytimeline/:id',        to: 'users#mytimeline',         as: :mytimeline
  get 'users/audiotimeline/:id',        to: 'users#audiotimeline',         as: :audiotimeline
  get 'users/:id',        to: 'users#show',         as: :homepage
  get 'users/notification/:id',       to: 'users#notification',       as: :notification
  get 'users/newfriend/:id',      to: 'users#newfriend',        as: :newfriend
  get 'unreadcomments/view_comment/:id',    to: 'unreadcomments#view_comment',         as: :viewcomm
  get 'unreadlikes/view_like/:id',    to: 'unreadlikes#view_like',         as: :viewlike

  get 'musics/comments/:id',      to: 'musics#allcomments',      as: :allcomments
  get 'audios/comments/:id',      to: 'audios#audioallcomments',      as: :audioallcomments

  put 'musics/likes/:id', to: "musics#like", as: :like_music
  put 'audios/likes/:id', to: "audios#like", as: :like_audio

  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"
  root 'sessions#create'
  # ...

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

