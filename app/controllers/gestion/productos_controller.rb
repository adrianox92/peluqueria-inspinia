class Gestion::ProductosController < GestionController
  def index
    @productos = Producto.all.order('activo DESC')
  end

  def new
    @producto = Producto.new
  end

  def create
    params[:producto][:base_compra] = params[:producto][:precio_compra].to_f / 1.21
    params[:producto][:iva_compra] = params[:producto][:precio_compra].to_f - params[:producto][:base_compra]

    producto = Producto.create(permit_params)
    if producto.valid?
      redirect_to gestion_productos_path
    else
      @producto = producto
      redirect_to new_gestion_producto_path
    end
  end

  def edit
    @producto = Producto.find(params[:id])
  end

  def update
    producto = Producto.find(params[:id])
    params[:producto][:base_compra] = params[:producto][:precio_compra].to_f / 1.21
    params[:producto][:iva_compra] = params[:producto][:precio_compra].to_f - params[:producto][:base_compra]
    if producto.update_attributes(permit_params)
      redirect_to gestion_productos_path
    else
      @producto = producto
      redirect_to edit_gestion_producto_path producto.id
    end
  end

  def destroy
    producto = Producto.find(params[:id])
    producto.destroy
    redirect_to gestion_productos_path
  end

  def show
    producto = Producto.find(params[:id])
    producto.destroy
    redirect_to gestion_productos_path
  end

  def permit_params
    params.require(:producto).permit(:nombre, :precio_compra, :precio_venta, :activo, :fecha_ultima_compra, :stock, :iva_compra, :base_compra)
  end
end