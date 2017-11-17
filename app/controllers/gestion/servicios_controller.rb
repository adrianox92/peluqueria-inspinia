class Gestion::ServiciosController < GestionController
  def index
    @precios = Precio.all.order('activo DESC')
  end

  def new
    @precio = Precio.new
  end

  def create
    precio = Precio.create(nombre: params[:precio][:nombre], coste: params[:precio][:coste], activo: params[:precio][:activo])
    if precio.valid?
      redirect_to gestion_servicios_path
    else
      @precio = precio
      redirect_to new_gestion_servicio_path
    end
  end

  def edit
    @precio = Precio.find(params[:id])
  end

  def update
    precio = Precio.find(params[:id])
    if precio.update_attributes(permit_params)
      redirect_to gestion_servicios_path
    else
      @precio = precio
      redirect_to edit_gestion_servicio_path precio.id
    end
  end

  def destroy
    precio = Precio.find(params[:id])

  end

  def show
    precio = Precio.find(params[:id])
    precio.destroy
    redirect_to gestion_servicios_path
  end

  def permit_params
    params.require(:precio).permit(:nombre, :coste, :activo)
  end
end