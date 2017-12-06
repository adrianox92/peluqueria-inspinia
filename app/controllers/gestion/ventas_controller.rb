class Gestion::VentasController < GestionController

  skip_before_action :verify_authenticity_token

  def index
    #Iniciamos la venta
    inicia_venta
    #Sacamos los datos necesarios para realizar la venta
    get_data
    servicio_venta = ServicioVenta.where('venta_id = ?', @venta.id)
    if servicio_venta.count > 0
      @servicios_asociados = servicio_venta
    end
  end

  def get_data
    @servicios = Precio.where('activo = ?', true)
    @tipo_pago = [['Efectivo', 'Efectivo'], ['Tarjeta', 'Tarjeta']]
    @productos = Producto.where('activo = ? AND stock > ?', true, 0) #Productos activos con stock
  end

  def inicia_venta
    #Cuando entremos en el index desde otra página que no provenga del controlador actual debemos mostrar la última venta que NO está cerrada
    #En caso contrario iniciamos una nueva
    ventas_abiertas = Venta.where('cerrada = ?', false)
    ultima_factura = ventas_abiertas.last


    #Tengo una venta abierta, cargo la última
    if ventas_abiertas.count > 0

      #Si tenemos una venta abierta del día anterior tenemos que avisar
      if ultima_factura.created_at.today?
        ventas_abiertas.last

        #Le ponemos el número de factura en caso de que no lo tenga
        venta = ventas_abiertas.last
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


  def aniade_venta
    #Antes de añadirlo a la venta debemos comprobar que existe, si ha llegado el ID es mas que probable que exista pero comprobamos que esté activo
    venta = Venta.find(params[:venta_id])
    servicio_venta = ''
    unless venta.cerrada #Si la venta está cerrada no puedo añadir nuevos elementos. No debería poder acceder a una venta cerrada desde aquí
      precio = Precio.find(params[:servicio])
      if precio.present? and precio.activo #Existe, continuamos la normal ejecución

        #Desglosamos el precio
        base = precio.coste / 1.21
        iva = precio.coste - base

        servicio_venta = ServicioVenta.create(
            base: base,
            precio_total: precio.coste,
            iva: iva,
            venta_id: params[:venta_id].to_i,
            servicio_id: params[:servicio].to_i,
            servicio_nombre_dn: precio.nombre
        )
      end
      #Una vez creado el servicio_venta tenemos que añadir también el precio a la venta en curso

      precio_total_actual = venta.precio_total
      nuevo_precio = precio_total_actual + precio.coste
      begin
        venta.update_attribute :precio_total, nuevo_precio
        render :json => {status: 'ok', precio_item: precio.coste, servicio_nombre_dn: precio.nombre, precio_total: nuevo_precio, tipo: 'servicio', id_item: servicio_venta.id}
      rescue => e
        e.backtrace
      end
    end
  end

  def aniade_producto
    #Antes de añadirlo a la venta debemos comprobar que existe, si ha llegado el ID es mas que probable que exista pero comprobamos que esté activo
    venta = Venta.find(params[:venta_id])
    servicio_venta = ''
    unless venta.cerrada #Si la venta está cerrada no puedo añadir nuevos elementos. No debería poder acceder a una venta cerrada desde aquí
      producto = Producto.find(params[:producto])
      if producto.present? and producto.activo and producto.stock > 0 #Existe, continuamos la normal ejecución

        #Desglosamos el precio
        base = producto.precio_venta / 1.21
        iva = producto.precio_venta - base

        servicio_venta = ServicioVenta.create(
            base: base,
            precio_total: producto.precio_venta,
            iva: iva,
            venta_id: params[:venta_id].to_i,
            producto_id: params[:producto].to_i,
            producto_nombre_dn: producto.nombre
        )
      end
      producto.update_attribute :stock, (producto.stock - 1) #Reducimos el stock del producto para llevar un control del mismo
      #Una vez creado el servicio_venta tenemos que añadir también el precio a la venta en curso

      precio_total_actual = venta.precio_total
      nuevo_precio = precio_total_actual + producto.precio_venta
      begin
        venta.update_attribute :precio_total, nuevo_precio
        render :json => {status: 'ok', precio_item: producto.precio_venta, producto_nombre_dn: producto.nombre, precio_total: nuevo_precio, tipo: 'producto', id_item: servicio_venta.id}
      rescue => e
        e.backtrace
      end
    end
  end

  def elimina_linea_venta
    venta = Venta.find(params[:venta_id])
    unless venta.cerrada #Si la venta está cerrada no puedo eliminar los elementos. No debería poder acceder a una venta cerrada desde aquí
      servicio_venta = ServicioVenta.find(params[:id])
      if servicio_venta.present?
        #Tenemos la linea en el código encontrada, debemos saber si es un producto o un servicio, no llega por parámetro
        if params[:tipo] == 'servicio'
          precio = Precio.find(servicio_venta.servicio_id)
          if precio.present? and precio.activo #Existe, continuamos la normal ejecución

            #Desglosamos el precio
            base = precio.coste / 1.21
            iva = precio.coste - base

            precio_total_actual = venta.precio_total
            nuevo_precio = precio_total_actual - precio.coste
            begin
              venta.update_attribute :precio_total, nuevo_precio
              render :json => {status: 'ok', precio_total: nuevo_precio, id: servicio_venta.id}
            rescue => e
              e.backtrace
            end
          end
        else #Si es un producto debemos restituir el stock
          producto = Producto.find(servicio_venta.producto_id)
          if producto.present? and producto.activo
            #Desglosamos el precio
            base = producto.precio_venta / 1.21
            iva = producto.precio_venta - base

            producto.update_attribute :stock, (producto.stock + 1) #Restituimos el stock del producto para llevar un control del mismo
            precio_total_actual = venta.precio_total
            nuevo_precio = precio_total_actual - producto.precio_venta
            begin
              venta.update_attribute :precio_total, nuevo_precio
              render :json => {status: 'ok', precio_total: nuevo_precio, id: servicio_venta.id}
            rescue => e
              e.backtrace
            end
          end
        end
        servicio_venta.destroy
      else
        render :json => {status: 'ko'}
      end
    end
  end

  def cierra_venta
    venta = Venta.find(params[:venta_id])
    if venta.present? and not venta.cerrada
      #Una vez vamos a cerrar la venta tenemos que calcular el IVA y la base de la venta
      precio_total = venta.precio_total
      base = precio_total / 1.21
      iva = precio_total - base

      venta.update_attributes(:cerrada => true, :base => base, :iva => iva, :tipo_pago => params[:venta][:tipo_pago])
      redirect_to gestion_ventas_path
    end
  end

  def permit_params_venta
    params.require(:venta).permit(:venta_nombre, :precio_total, :base, :iva, :tipo_pago)
  end

  def permit_params_servicio_venta
    params.require(:servicio_venta).permit(:base, :iva, :precio_total, :servicio_id, :venta_id, :servicio_nombre_dn)
  end

  private
  #El nombre de las facturas será el AÑO MES y número de factura acumulado del año entero
  def nombra_factura (venta)
    anyo = Time.current.year
    mes = Time.now.strftime("%m").to_i
    ultima_factura = (venta.present?) ? venta.id + 1 : 1
    factura = "#{anyo}#{mes}#{ultima_factura}"
  end
end