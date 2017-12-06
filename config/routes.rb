Myapp::Application.routes.draw do

  root 'gestion#index'

  get 'login' => 'gestion#login', as: 'login'
  post 'login' => 'gestion#login'
  get 'logout' => 'gestion#logout', as: 'logout'

  namespace :gestion do
    resources :ventas do
      post 'aniade_venta/:servicio' => 'ventas#aniade_venta'
      post 'aniade_producto/:producto' => 'ventas#aniade_producto'
      post 'elimina_linea_venta/:id/:tipo' => 'ventas#elimina_linea_venta'
      post 'cierra_venta' => 'ventas#cierra_venta'
    end
    resources :servicios
    resources :productos
    resources :informes
    resources :estadisticas
    resources :pagos
  end
end
