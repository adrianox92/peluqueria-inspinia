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
    resources :clientes do
      collection do
        get 'filtrar_clientes/:cliente' => 'clientes#filtrar_clientes', as: 'filtrar_clientes'
        get 'resetear_filtros/' => 'clientes#resetear_filtros', as: 'resetear_filtros'
      end
      member do
        get 'new_tinte'
        get 'edit_tinte/:tinte_id' => 'clientes#edit_tinte', as: 'editar_tinte'
      end
    end
    resources :tintes
    resources :clientes_tintes
    resources :configuraciones

  end
end
