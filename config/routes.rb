Transit::Application.routes.draw do
  # root :to => 'main#index'
  root :to => 'main#home'
  match ':controller(/:action(/:id))'
end
