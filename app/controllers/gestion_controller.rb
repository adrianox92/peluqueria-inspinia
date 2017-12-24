class GestionController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login, except: :login
  before_action :muestra_notificaciones

  def index

  end

  def login
    if request.post?
      clave = Digest::MD5.hexdigest(params[:usuario][:clave])
      usuario = Usuario.where('nombre = ? AND clave = ?',params[:usuario][:nombre],clave).first
      if usuario.present?
        Usuario.find(usuario.id).update(last_login_at: DateTime.now)
        session[:logged_as] = usuario.id
        session[:logged_name] = usuario.nombre
        redirect_to root_path
      else
        @usuario = Usuario.new
      end
    else
      @usuario = Usuario.new
    end
  end

  def logout
    reset_session
    redirect_to login_path
  end

  private

  def require_login
    unless session[:logged_as]
      redirect_to login_path
    end
  end

  #Muestra los productos stock menor de 10
  def muestra_notificaciones
    @notificaciones = Producto.stock_bajo
  end

end


