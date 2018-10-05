class Gestion::InformesController < GestionController

  skip_before_action :verify_authenticity_token

  def index
    get_selectores
    recuerda_busqueda

    @informe = filtrar_listado(params)
    @partial = session[:filtro_tipo].downcase if session[:filtro_tipo].present?
  end


  def generar_pdf

    extrae_datos_informe(session[:filtro_tipo], session[:filtro_fecha_inicio], session[:filtro_fecha_fin], session[:filtro_orden])
    #TODO: instalar wkhtmltopdf en el ordenador a usar https://wkhtmltopdf.org/downloads.html

    nombre_pdf = "/gestion/informes/informes_#{session[:filtro_tipo].downcase}.html.erb"
    respond_to do |format|
      format.pdf do
        render :pdf => "informe.pdf", :template => nombre_pdf, encoding: 'UTF8', title: "Informe de #{session[:filtro_tipo]}"
      end
    end
  end

  def get_selectores
    @tipo = [['Ventas', 'Venta'], ['Pagos', 'Pago'], ['Productos', 'Producto'], ['Servicios', 'ServicioVenta'], ['Repostajes', 'Gasolina']]
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

  def extrae_datos_informe(modelo, fecha_inicio, fecha_fin, orden)

    parametros = {
        :filtro_tipo => modelo,
        :filtro_fecha_inicio => fecha_inicio,
        :filtro_fecha_fin => fecha_fin,
        :filtro_orden => orden,
    }


    resultados = filtrar_listado(parametros)

    case parametros[:filtro_tipo]
      when 'Venta'
        get_informe_ventas(resultados)
      when 'Pago'
        get_informe_gastos(resultados)
      when 'Producto'
        get_informe_productos(resultados)
      when 'Gasolina'
        get_informe_gasolina(resultados)
    end
  end

  private

  #Sacamos las ventas según los datos que nos llegan por parte del cliente
  def get_informe_ventas(informe)
    linea_venta = {}
    ingresos = 0
    subtotal = 0
    iva = 0
    informe.each do |i|
      servicios = ''
      ingresos = ingresos + i.precio_total
      subtotal = subtotal + i.base
      iva = iva + i.iva
      sv = ServicioVenta.where('venta_id = ?', i.id)
      sv.each do |s|
        if s.servicio_id.present? #Es un servicio
          servicios << "#{Precio.find(s.servicio_id).nombre} "
        else #Es un producto
          servicios << "#{Producto.find(s.producto_id).nombre} "
        end
      end
      linea_venta["venta_#{i.id}".to_sym] = {venta_nombre: i.venta_nombre, precio_total: i.precio_total, base: i.base, iva: i.iva, tipo_pago: i.tipo_pago, cliente_id: i.cliente_id, fecha_venta: i.created_at, servicios: servicios}
    end
    @linea_venta = linea_venta
    @base = subtotal
    @iva = iva
    @ingresos = ingresos
  end

  def get_informe_productos(informe)
    total_compras = 0
    total_ventas = 0
    iva_compra = 0
    subtotal_compra = 0
    iva_venta = 0
    subtotal_venta = 0
    linea_producto = {}
    informe.each do |i|
      total_compras = total_compras + i.precio_compra
      subtotal_compra = subtotal_compra + i.base_compra
      iva_compra = iva_compra + i.iva_compra
      linea_producto["producto_#{i.id}".to_sym] = {nombre: i.nombre, pago: i.precio_compra, base: i.base_compra, iva: i.iva_compra, fecha_creado: i.created_at, ultima_compra: i.fecha_ultima_compra, tipo: i.tipo}
    end
    @base = subtotal_compra
    @iva = iva_compra
    @productos = total_compras
    @linea_producto = linea_producto
  end

  def get_informe_gastos(informe)
    total_gastos = 0
    subtotal = 0
    iva = 0
    linea_gasto = {}
    informe.each do |i|
      total_gastos = total_gastos + i.pago
      subtotal = subtotal + i.base
      iva = iva + i.iva
      linea_gasto["pago_#{i.id}".to_sym] = {nombre: i.nombre, pago: i.pago, base: i.base, iva: i.iva, fecha: i.created_at}
    end
    @base = subtotal
    @iva = iva
    @gastos = total_gastos
    @linea_gasto = linea_gasto
  end

  def get_informe_gasolina(informe)
    total_gastos = 0
    linea_gasto = {}
    informe.each do |i|
      total_gastos = total_gastos + i.precio_total
      linea_gasto["gasolina_#{i.id}".to_sym] = {vehiculo: i.vehiculo.nombre, precio_litro: i.precio_litro, litros: i.litros, gasolinera: i.gasolinera, fecha: i.created_at, precio_total: i.precio_total, kilometros: i.kilometros}
    end
    @gastos = total_gastos
    @linea_gasto = linea_gasto
  end
end