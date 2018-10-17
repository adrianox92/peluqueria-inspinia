class Gestion::EstadisticasController < GestionController

  def index
    begin
      ventas = Venta.where('cerrada = ?', true) #Sacamos todas las ventas cerradas para mostrar los datos en pantalla según la caja

      #Semana en curso
      ventas_semana_en_curso = ventas.where("created_at >= ?", Time.current.beginning_of_week)

      from = Time.current.beginning_of_week.beginning_of_day
      to = Time.current.end_of_week

      ventas_semana_total_hm = get_ventas_periodo(from, to)
      @ventas_semana_total = ventas_semana_total_hm[1].to_json

      @ventas_semana = ventas_semana_total_hm[0]
      @pagos_tarjeta = ventas_semana_total_hm[2].where("tipo_pago = ?", 'Tarjeta').count
      @pagos_efectivo = ventas_semana_total_hm[2].where("tipo_pago = ?", 'Efectivo').count

      total_comision = 0
      ventas_semana_total_hm[2].where("tipo_pago = ?", 'Tarjeta').each do |c|
        total_comision = total_comision + c.comision_tarjeta
      end

      @total_comision = total_comision

      @iva_repercutido = 0
      ventas_semana_en_curso.each do |vsc|
        @iva_repercutido = @iva_repercutido + vsc.iva
      end if @ventas_semana > 0

      @iva_soportado = 0
      compras_semana_en_curso = Producto.where("fecha_ultima_compra >= ?", Time.current.beginning_of_week)
      compras_semana_en_curso.each do |csc|
        @iva_soportado = @iva_soportado + csc.iva_compra
      end if compras_semana_en_curso.count > 0


      from_semana_anterior = Time.current.beginning_of_week - 7.days
      to_semana_anterior = Time.current.beginning_of_week

      ventas_semana_anterior = get_ventas_periodo(from_semana_anterior, to_semana_anterior)
      @ventas_semana_anterior_total = ventas_semana_anterior[1].to_json


      @diferencia_ventas = devuelve_diferencia(ventas_semana_anterior[0], @ventas_semana)
      @ventas_semana_anterior = ventas_semana_anterior[0]

      @ingresos_semana = ingresos (ventas_semana_en_curso) #Ingresos de la semana en curso
      @ingresos_semana_anterior = ingresos(ventas_semana_anterior[2])


      @diferencia_ingresos = devuelve_diferencia(@ingresos_semana_anterior, @ingresos_semana)


      #Mes en curso
      ventas_mes = ventas.where("created_at >= ? AND created_at <= ?", (Time.current.beginning_of_month), Time.current.end_of_month)
      @ventas_mes = ventas_mes.count
      @ingresos_mes = ingresos(ventas_mes)

      ventas_mes_anterior = ventas.where("created_at >= ? AND created_at <= ?", (Time.current.beginning_of_month - 1.month), Time.current.end_of_month - 1.month)
      num_ventas_mes_anterior = ventas_mes_anterior.count

      @diferencia_ventas_meses = devuelve_diferencia(num_ventas_mes_anterior, @ventas_mes)

      ingresos_mes_anterior = ventas.where("created_at >= ? AND created_at <= ?", (Time.current.beginning_of_month - 1.month), Time.current.end_of_month - 1.month)
      total_ingresos_mes_anterior = ingresos(ingresos_mes_anterior)

      @diferencia_ingresos_meses = devuelve_diferencia(total_ingresos_mes_anterior, @ingresos_mes)


      #General


      @ventas = ventas

      #Sacamos los gastos del mes y después calculamos la diferencia para saber si hay beneficio.
      pagos = Pago.where('ultimo_pago >= ? AND ultimo_pago <= ?', Time.current.beginning_of_month, Time.current.end_of_month)
      @total_gastos = devuelve_total_gastos(pagos)
      @total_mes = ingresos_gastos(@ingresos_mes, @total_gastos)

    rescue => e
      e.backtrace
    end
  end

  def comparacion_ventas
    from = Time.current.beginning_of_week.beginning_of_day
    to = Time.current.end_of_week

    ventas_semana_total_hm = get_ventas_periodo(from, to)
    @ventas_semana_total = ventas_semana_total_hm[1].to_json

    #Ventas de la semana anterior
    from_semana_anterior = Time.current.beginning_of_week - 7.days
    to_semana_anterior = Time.current.beginning_of_week

    ventas_semana_anterior = get_ventas_periodo(from_semana_anterior, to_semana_anterior)
    @ventas_semana_anterior_total = ventas_semana_anterior[1].to_json

    return @ventas_semana_total, @ventas_semana_anterior
  end

  def devuelve_servicios
    begin
      #Sacamos las ventas de esta semana si nos llega true, sino las del mes.
      if params[:current_week] == 'true'
        periodo_inicio = Time.current.beginning_of_week
        periodo_fin = Time.current.end_of_week.strftime("%d/%m/%Y")
      else
        periodo_inicio = Time.current.beginning_of_month.strftime("%d/%m/%Y")
        periodo_fin = Time.current.end_of_month.strftime("%d/%m/%Y")
      end

      #Sacamos los ID's de las ventas para buscar los servicios.
      ventas_ids = Venta.where('cerrada = ? AND created_at >= ? AND created_at <= ?', true, periodo_inicio, periodo_fin).ids #Sacamos los IDS de las ventas de la semana
      servicio_venta = ServicioVenta.where('venta_id IN (?) AND servicio_id IS NOT NULL', ventas_ids).order('servicio_id')
      data = {}
      servicio_id = 0
      usado = 0
      servicio_venta.each do |serven|
        if servicio_id != serven.servicio_id
          usado = 0
          usado = usado + 1
          servicio_id = serven.servicio_id
        else
          usado = usado + 1
        end
        data[serven.servicio_nombre_dn.to_sym] = {usado: usado}
      end if servicio_venta.count > 0
      data.to_json
      render :json => data
    rescue => e
      e.backtrace
    end
  end


  private
  def ingresos (ventas)
    ingresos_totales = 0
    ventas.each do |v|
      precio_total = (v.precio_total).present? ? v.precio_total : 0
      ingresos_totales = ingresos_totales + precio_total
    end
    ingresos_totales
  end

  def ingresos_gastos (ingresos, gastos)
    balance_mensual = 0
    balance_mensual = ingresos - gastos
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


  #Metodo que devuelve las ventas entre los periodos
  # @params fecha_inicio [Date]
  # @params fecha_fin [Date]
  # return num_ventas[Integer], ventas_semana_hm[HashMap], ventas[ActiveRecord]
  def get_ventas_periodo(fecha_inicio, fecha_fin)
    total_semana = 0
    dia = ''
    ventas = Venta.where("created_at >= ? AND created_at < ? AND cerrada = ?", fecha_inicio, fecha_fin, true).order('created_at')

    ventas_semana_hm = {}

    Date.new(fecha_inicio.year, fecha_inicio.month, fecha_inicio.day).upto(Date.new(fecha_fin.year, fecha_fin.month, fecha_fin.day)) do |date|
      ventas_semana_hm["dia_#{date.wday}".to_sym] = {dia: date.wday, total_ventas: 0}
    end
    num_ventas = ventas.count

    ventas.each do |vsa|

      if vsa.created_at.strftime("%d/%m/%Y") != dia
        total_semana = 0
        dia = vsa.created_at.strftime("%d/%m/%Y")
        total_actual = ((vsa.precio_total).present? ? vsa.precio_total : 0)
        total_semana = total_semana + total_actual
      else
        total_actual = ((vsa.precio_total).present? ? vsa.precio_total : 0)
        total_semana = total_semana + total_actual
      end
      ventas_semana_hm["dia_#{vsa.created_at.strftime("%d/%m/%Y").to_date.wday}".to_sym] = {dia: vsa.created_at.strftime("%d/%m/%Y").to_date.wday, total_ventas: total_semana}
    end if num_ventas > 0

    return num_ventas, ventas_semana_hm, ventas

  end


  def devuelve_total_gastos(pagos)
    total_gastos = 0
    if pagos.count > 0
      pagos.each do |p|
        total_gastos = total_gastos + p.pago
      end
    else
      total_gastos = 0
    end
    return total_gastos
  end

end