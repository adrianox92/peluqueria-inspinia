class Gestion::EstadisticasController < GestionController

  def index
    ventas = Venta.where('cerrada = ?', true) #Sacamos todas las ventas cerradas para mostrar los datos en pantalla según la caja

    #Semana en curso
    ventas_semana_en_curso = ventas.where("created_at >= ?", Time.zone.now.beginning_of_week)

    #TODO: Refactorizar a 1 única función
    from = Time.zone.now.beginning_of_week.beginning_of_day
    to = Time.zone.now.end_of_week
    ventas_semana_total_hm = {}

    Date.new(from.year, from.month, from.day).upto(Date.new(to.year, to.month, to.day)) do |date|
      ventas_semana_total_hm["dia_#{date.wday}".to_sym] = {dia: date.wday, total_ventas: 0}
    end

    ventas_semana_total = Venta.where(created_at: from .. to)

    dia = ''
    total_semana_curso = 0
    ventas_semana_total.each do |vsc|

      if vsc.created_at.strftime("%d/%m/%Y")
        dia = vsc.created_at.strftime("%d/%m/%Y")
        total_semana_curso = total_semana_curso + vsc.precio_total
      else
        total_semana_curso = total_semana_curso + vsc.precio_total
      end
      ventas_semana_total_hm["dia_#{vsc.created_at.strftime("%d/%m/%Y").to_date.wday}".to_sym] = {dia: vsc.created_at.strftime("%d/%m/%Y").to_date.wday, total_ventas: total_semana_curso}
    end if ventas_semana_total.count > 0

    @ventas_semana_total = ventas_semana_total_hm.to_json

    @ventas_semana = ventas_semana_en_curso.count
    @pagos_tarjeta = ventas_semana_en_curso.where("tipo_pago = ?", 'Tarjeta').count
    @pagos_efectivo = ventas_semana_en_curso.where("tipo_pago = ?", 'Efectivo').count

    @iva_repercutido = 0
    ventas_semana_en_curso.each do |vsc|
      @iva_repercutido = @iva_repercutido + vsc.iva
    end if @ventas_semana > 0

    @iva_soportado = 0
    compras_semana_en_curso = Producto.where("fecha_ultima_compra >= ?", Time.zone.now.beginning_of_week)
    compras_semana_en_curso.each do |csc|
      @iva_soportado = @iva_soportado + csc.iva_compra
    end if compras_semana_en_curso.count > 0


    #TODO: Refactorizar a 1 única función
    ventas_semana_anterior = ventas.where("created_at >= ? AND created_at < ?", (Time.zone.now.beginning_of_week - 7.days), Time.zone.now.beginning_of_week)
    total_semana_anterior = 0
    ventas_semana_anterior_total_hm = {}

    from_semana_anterior = Time.zone.now.beginning_of_week - 7.days
    to_semana_anterior = Time.zone.now.beginning_of_week
    Date.new(from_semana_anterior.year, from_semana_anterior.month, from_semana_anterior.day).upto(Date.new(to_semana_anterior.year, to_semana_anterior.month, to_semana_anterior.day)) do |date|
      ventas_semana_anterior_total_hm["dia_#{date.wday}".to_sym] = {dia: date.wday, total_ventas: 0}
    end
    num_ventas_anterior = ventas_semana_anterior.count

    ventas_semana_anterior.each do |vsa|

      if vsa.created_at.strftime("%d/%m/%Y")
        dia = vsa.created_at.strftime("%d/%m/%Y")
        total_semana_anterior = total_semana_anterior + vsa.precio_total
      else
        total_semana_anterior = total_semana_anterior + vsa.precio_total
      end
      ventas_semana_anterior_total_hm["dia_#{vsa.created_at.strftime("%d/%m/%Y").to_date.wday}".to_sym] = {dia: vsa.created_at.strftime("%d/%m/%Y").to_date.wday, total_ventas: total_semana_anterior}
    end if num_ventas_anterior > 0

    @ventas_semana_anterior_total = ventas_semana_anterior_total_hm.to_json

    cero = false #Se lo pasamos al comparador para que sume 1 mas en caso de que sea 0 y no de un valor incorrecto
    if num_ventas_anterior == 0
      cero = true
    end

    @diferencia_ventas = devuelve_diferencia(num_ventas_anterior, @ventas_semana, cero)

    @ingresos_semana = ingresos (ventas_semana_en_curso) #Ingresos de la semana en curso
    ingresos_semana_anterior = ingresos(ventas_semana_anterior)

    cero_ingresos = false

    if ingresos_semana_anterior == 0 #Si es 0 lo tenemos que igualar a 1 para que no de error
      cero_ingresos = true
    end
    @diferencia_ingresos = devuelve_diferencia(ingresos_semana_anterior, @ingresos_semana, cero_ingresos)


    #Mes en curso
    ventas_mes = ventas.where("created_at >= ? AND created_at <= ?", (Time.zone.now.beginning_of_month), Time.zone.now.end_of_month)
    @ventas_mes = ventas_mes.count
    @ingresos_mes = ingresos(ventas_mes)

    ventas_mes_anterior = ventas.where("created_at >= ? AND created_at <= ?", (Time.zone.now.beginning_of_month - 1.month), Time.zone.now.end_of_month - 1.month)
    num_ventas_mes_anterior = ventas_mes_anterior.count
    cero_ventas_mes_anterior = false
    if num_ventas_mes_anterior == 0 #Si es 0 lo tenemos que igualar a 1 para que no de error
      cero_ventas_mes_anterior = true
    end
    @diferencia_ventas_meses = devuelve_diferencia(num_ventas_mes_anterior, @ventas_mes, cero_ventas_mes_anterior)

    ingresos_mes_anterior = ventas.where("created_at >= ? AND created_at <= ?", (Time.zone.now.beginning_of_month - 1.month), Time.zone.now.end_of_month - 1.month)
    total_ingresos_mes_anterior = ingresos(ingresos_mes_anterior)

    @diferencia_ingresos_meses = devuelve_diferencia(total_ingresos_mes_anterior, @ingresos_mes)


    #General
    @productos_semana = devuelve_productos(Time.zone.now.beginning_of_week, Time.zone.now.end_of_week.strftime("%d/%m/%Y"))

    @ventas = ventas
  end


  private
  def ingresos (ventas)
    ingresos_totales = 0
    ventas.each do |v|
      ingresos_totales = ingresos_totales + v.precio_total
    end
    ingresos_totales
  end

  def devuelve_diferencia (anterior, actual, cero = nil)

    if cero
      anterior = 1
      diferencia_ventas = ((actual - anterior) / anterior) * 100
    else
      diferencia_ventas = ((actual - anterior) / anterior) * 100
    end


  end

  def devuelve_productos(periodo_inicio, periodo_fin)
    ventas_ids = Venta.where('cerrada = ? AND created_at >= ? AND created_at <= ?', true, periodo_inicio, periodo_fin).ids #Sacamos los IDS de las ventas de la semana
    servicio_venta = ServicioVenta.where('venta_id IN (?) AND servicio_id IS NOT NULL', ventas_ids).order('servicio_id')
    data = {}
    servicio_id = 0
    total_servicio = 0
    usado = 0
    servicio_venta.each do |serven|
      if servicio_id != serven.servicio_id
        total_servicio = 0
        total_servicio = total_servicio + serven.precio_total
        usado = 0
        usado = usado + 1
        servicio_id = serven.servicio_id
      else
        total_servicio = total_servicio + serven.precio_total
        usado = usado + 1
      end
      data[serven.servicio_nombre_dn.to_sym] = {total_servicio: total_servicio, usado: usado}
    end
    data.to_json
  end
end