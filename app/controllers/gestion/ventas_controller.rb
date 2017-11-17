class Gestion::VentasController < GestionController
  def index
    inicia_venta
    get_data
  end

  def get_data
    @servicios = Precio.where('activo = ?', true)
    @tipo_pago = [['Efectivo'], ['Tarjeta']]
  end

  def inicia_venta
    #Cuando entremos en el index desde otra página que no provenga del controlador actual debemos mostrar la última venta que NO está cerrada
    #En caso contrario iniciamos una nueva
    if Rails.application.routes.recognize_path(request.referrer)[:controller] != 'gestion/ventas'
      ventas_abiertas = Venta.where('cerrada = ?', false)
      ultima_factura = Venta.order('created_at').last



      #Tengo una venta abierta, cargo la última
      if ventas_abiertas.count > 0
        ventas_abiertas.order('created_at DESC').first

        #Le ponemos el número de factura en caso de que no lo tenga
        venta = ventas_abiertas.first
        unless venta.venta_nombre.present?
          venta.update_attribute :venta_nombre, nombra_factura(ultima_factura)
        end
        @venta = venta
      else
        venta_nueva = Venta.create(:venta_nombre => nombra_factura(ultima_factura))
        @venta = venta_nueva
      end
    else
      venta_nueva = Venta.create(:venta_nombre => nombra_factura(ultima_factura))
      @venta = venta_nueva
    end
  end

  def permit_params
    params.require(:venta).permit(:venta_nombre, :precio_total, :base, :iva, :tipo_pago)
  end

  private
  #El nombre de las facturas será el AÑO MES y número de factura acumulado del año entero
  def nombra_factura (venta)
    anyo = Time.current.year
    mes = Time.now.strftime("%m").to_i
    ultima_factura = (venta.present?) ? venta.id : 1
    factura = "#{anyo}#{mes}#{ultima_factura}"
  end
end