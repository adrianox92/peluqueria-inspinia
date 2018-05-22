class Gestion::GasolinasController < GestionController

  def index
    @gasolinas = Gasolina.all.order('id DESC')
  end


  def new
    fill_form
    @gasolina = Gasolina.new
  end

  def create
    gasolina = Gasolina.create(permit_params)

    if gasolina.valid?
      redirect_to gestion_gasolinas_path
    else
      @gasolina = gasolina
      render :new
    end
  end

  def edit
    fill_form
    @gasolina = Gasolina.find(params[:id])
  end

  def update
    gasolina = Gasolina.find(params[:id])
    if gasolina.update_attributes(permit_params)
      redirect_to gestion_gasolinas_path
    else
      @gasolina = gasolina
      redirect_to edit_gestion_gasolina_path(gasolina.id)
    end
  end

  def destroy
    gasolina = Gasolina.find(params[:id])
    gasolina.destroy
    redirect_to gestion_gasolinas_path
  end

  def fill_form
    @vehiculos = Vehiculo.all.order('id').map{|v| [v.nombre, v.id]}
  end

  def permit_params
    params.require(:gasolina).permit(:precio_total, :litros, :precio_litro, :vehiculo_id, :gasolinera, :tipo_gasolina, :kilometros, :fecha_repostaje)
  end
end
