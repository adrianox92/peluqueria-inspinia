class Gestion::InformesController < GestionController

  skip_before_action :verify_authenticity_token

  def index
    get_selectores
    recuerda_busqueda

    @informe = filtrar_listado(params)
    @partial = session[:filtro_tipo].downcase if session[:filtro_tipo].present?
  end


  def generar_pdf

    #TODO: instalar wkhtmltopdf en el ordenador a usar https://wkhtmltopdf.org/downloads.html
    respond_to do |format|
      format.pdf do
        render  :pdf => "informe.pdf", :template => 'gestion/informes/informes.html.erb', encoding: 'UTF8'
      end
    end
  end

  def get_selectores
    @tipo = [['Ventas', 'Venta'], ['Pagos', 'Pago'], ['Productos', 'Producto'], ['Servicios', 'ServicioVenta']]
    @filtro_fecha_inicio = (params[:filtro_fecha_inicio].blank? or (params[:filtro_fecha_inicio] =~ /\d{2}\/\d{2}\/\d{4}/).nil?) ? Date.today.beginning_of_month : Date.parse(params[:filtro_fecha_inicio])
    @filtro_fecha_fin = (params[:filtro_fecha_fin].blank? or (params[:filtro_fecha_fin] =~ /\d{2}\/\d{2}\/\d{4}/).nil?) ? Date.today.end_of_month : Date.parse(params[:filtro_fecha_fin])
    @orden = [['Fecha', 'fecha'], ['Importe', 'importe']]
  end

  def recuerda_busqueda
    recordables = [:filtro_fecha_inicio, :filtro_fecha_fin, :filtro_tipo, :filtro_orden]
    recordables.each { |i| session.delete(i) }
    recordables.each { |i| session[i] = params[i] if (params.has_key? i) }
  end

  def filtrar_listado(parametros)
    orden = ''
    case parametros[:filtro_orden]
      when 'fecha'
        orden = 'created_at DESC'
      when 'importe'
        case parametros[:filtro_tipo]
          when 'Venta'
            orden = 'precio_total DESC'
          when 'Pago'
            orden = 'pago DESC'
          when 'Producto'
            orden = 'precio_compra DESC'
          when 'ServicioVenta'
            orden = 'pago DESC'
        end
    end
    if parametros[:filtro_tipo].present?
      consulta = parametros[:filtro_tipo].constantize
      consulta = consulta.where("created_at >= ? ", (parametros[:filtro_fecha_inicio]))
      consulta = consulta.where("created_at <= ?", (parametros[:filtro_fecha_fin]))
      if parametros[:filtro_tipo] == 'Venta'
        consulta = consulta.where('cerrada = ?', true)
      end
      consulta = consulta.order(orden)
      consulta
    end
  end
end