class GestionController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login, except: :login
  before_action :muestra_notificaciones
  def index

    @ingresos = ingresos

    @ingresos_mes_anterior = ingresos_mes_anterior
    @diferencia_ingresos = devuelve_diferencia(@ingresos_mes_anterior, @ingresos)

    @clientes = Cliente.where('activo = true')

    @citas = Cita.where('created_at >= ? AND created_at <= ?',Time.current.beginning_of_week, Time.current.end_of_week)
  end

  def login
    if request.post?
      clave = Digest::MD5.hexdigest(params[:usuario][:clave])
      usuario = Usuario.where('nombre = ? AND clave = ?',params[:usuario][:nombre],clave).first
      if usuario.present?
        Usuario.find(usuario.id).update(last_login_at: DateTime.now)
        session[:logged_as] = usuario.id
        session[:logged_name] = usuario.nombre
        session[:logged_group] = usuario.empresa.nombre
        session[:logged_group_id] = usuario.empresa_id

        empresa = Empresa.find(usuario.empresa_id)

        session[:iva] = empresa.iva
        session[:comision_tarjeta] = empresa.comision_tarjeta
        session[:stock_bajo] = empresa.stock_bajo

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
    @notificaciones = Producto.stock_bajo(session[:stock_bajo])
  end

  #Devuelve el iva establecido por el cliente para realizar los cálculos oportunos en la aplicación
  def devuelve_iva
    iva = 1 + (session[:iva].to_f / 100)
  end

  def devuelve_comision_tarjeta
    comision = 1 + (session[:comision_tarjeta].to_f / 100)
  end

  def ingresos
    ingresos_totales = 0
    Venta.where('created_at >= ? AND created_at <= ? AND cerrada = true', Date.today.at_beginning_of_month, Date.today.end_of_month).each do |v|
      precio_total = (v.precio_total).present? ? v.precio_total : 0
      ingresos_totales = ingresos_totales + precio_total
    end
    ingresos_totales
  end

  def ingresos_mes_anterior
    ingresos_totales = 0
    Venta.where('created_at >= ? AND created_at <= ? AND cerrada = true', Date.today.at_beginning_of_month.last_month, Date.today.end_of_month.last_month).each do |v|
      precio_total = (v.precio_total).present? ? v.precio_total : 0
      ingresos_totales = ingresos_totales + precio_total
    end
    ingresos_totales
  end

  def devuelve_diferencia (anterior, actual)

    if anterior == 0
      anterior_falso = 1
      diferencia_ventas = ((actual - anterior_falso).to_f / anterior_falso) * 100
    else
      diferencia_ventas = ((actual - anterior).to_f / anterior) * 100
    end
    diferencia_ventas
  end

end


