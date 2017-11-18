class Gestion::EstadisticasController < GestionController

  def index
    ventas = Venta.where('cerrada = ?', true) #Sacamos todas las ventas cerradas para mostrar los datos en pantalla según la caja

    #Semana en curso
    ventas_semana_en_curso = ventas.where("created_at >= ?", Time.zone.now.beginning_of_week)
    @ventas_semana = ventas_semana_en_curso.count
    ventas_semana_anterior = ventas.where("created_at >= ? AND created_at < ?", (Time.zone.now.beginning_of_week - 7.days), Time.zone.now.beginning_of_week)
    num_ventas_anterior = ventas_semana_anterior.count
    cero = false #Se lo pasamos al comparador para que sume 1 mas en caso de que sea 0 y no de un valor incorrecto
    if num_ventas_anterior == 0 #Si es 0 lo tenemos que igualar a 1 para que no de error
      num_ventas_anterior = 1
      cero = true
    end

    @diferencia_ventas = devuelve_diferencia(num_ventas_anterior, @ventas_semana, cero)


    @ingresos_semana = ingresos (ventas_semana_en_curso) #Ingresos de la semana en curso
    ingresos_semana_anterior = ingresos(ventas_semana_anterior)

    cero_ingresos = false

    if ingresos_semana_anterior == 0 #Si es 0 lo tenemos que igualar a 1 para que no de error
      ingresos_semana_anterior = 1
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
      num_ventas_mes_anterior = 1
      cero_ventas_mes_anterior = true
    end
    @diferencia_ventas_meses = devuelve_diferencia(num_ventas_mes_anterior, @ventas_mes, cero_ventas_mes_anterior)

    ingresos_mes_anterior = ventas.where("created_at >= ? AND created_at <= ?", (Time.zone.now.beginning_of_month - 1.month), Time.zone.now.end_of_month - 1.month)
    total_ingresos_mes_anterior = ingresos(ingresos_mes_anterior)

    @diferencia_ingresos_meses = devuelve_diferencia(total_ingresos_mes_anterior, @ingresos_mes)


    #General
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

    if anterior > actual #Decrece
      diferencia_ventas = (anterior-actual)/actual * 100
    else #Aumenta
      diferencia_ventas = (actual - anterior)/anterior * 100
      if cero
        diferencia_ventas = diferencia_ventas + 100
      end
    end
    diferencia_ventas
  end
end