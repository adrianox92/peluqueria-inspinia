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
    resources :informes do
      collection do
        get 'generar_pdf/' => 'informes#generar_pdf', as: 'generar_pdf'
      end
    end
    resources :estadisticas do
      collection do
        get 'devuelve_productos/:current_week' => 'estadisticas#devuelve_servicios', as: 'devuelve_servicios'
      end
    end
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
    resources :citas
    resources :gasolinas

    resources :roles
    resources :administraciones
    resources :usuarios
    resources :permisos
  end
end
