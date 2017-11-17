class Gestion::PreciosController < GestionController
  def index
    @precios = Precio.all
  end

  def new
    @precio = Precio.new
  end

  def create
    precio = Precio.create(nombre: params[:precio][:nombre], coste: params[:precio][:coste], activo: params[:precio][:activo])
    if precio.valid?
      redirect_to gestion_precios_path
    else
      @precio = precio
      redirect_to new_gestion_precio_path
    end
  end

  def edit
    @precio = Precio.find(params[:id])
  end

  def update
    precio = Precio.find(params[:id])
    if precio.update_attributes(permit_params)
      redirect_to gestion_precios_path
    else
      render edit
    end
  end

  def destroy
    precio = Precio.find(params[:id])

  end

  def show
    precio = Precio.find(params[:id])
    precio.destroy
    redirect_to gestion_precios_path
  end

  def permit_params
    params.require(:precio).permit(:nombre, :precio, :activo)
  end
end