ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'main'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.page '/page/:name', :controller => 'pages', :action => 'show', :name => nil

  map.resources :users
  map.resources :products, :collection => {:finished => :get}
  map.resource :session

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
