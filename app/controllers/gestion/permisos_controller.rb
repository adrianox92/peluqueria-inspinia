class Gestion::PermisosController < GestionController

  def index
    obtener_permisos
  end

  def new
    @permiso = Permiso.new
  end

  def edit
    @permiso = Permiso.find(params[:id])
  end

  def create
    permiso = Permiso.create(permit_params)

    if permiso.valid?
      redirect_to gestion_permisos_path
    else
      @permiso = permiso

      render :new
    end
  end

  def update
    permiso = Permiso.find(params[:id])
    if permiso.update_attributes(permit_params)
      redirect_to gestion_permisos_path
    else
      @permiso = permiso
      redirect_to gestion_permiso_path permiso.id
    end
  end

  def destroy
    permiso = Permiso.find(params[:id])
    permiso.destroy
    redirect_to gestion_permisos_path
  end

  def permit_params
    params.require(:permiso).permit(:nombre, :descripcion)
  end

  private

  def obtener_permisos
    @permisos = Permiso.all.order('id')
  end


end
