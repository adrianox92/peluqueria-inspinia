class Gestion::RolesController < GestionController

  def index
    obtener_roles
  end

  def new
    @rol = Rol.new
  end

  def edit
    @rol = Rol.find(params[:id])
  end

  def create
    rol = Rol.create(permit_params)

    if rol.valid?
      redirect_to gestion_roles_path
    else
      @rol = rol

      render :new
    end
  end

  def update
    rol = Rol.find(params[:id])
    if rol.update_attributes(permit_params)
      redirect_to gestion_roles_path
    else
      @rol = rol
      redirect_to gestion_rol_path rol.id
    end
  end

  def destroy
    rol = Rol.find(params[:id])
    rol.destroy
    redirect_to gestion_roles_path
  end

  def permit_params
    params.require(:rol).permit(:nombre, :descripcion)
  end

  private

  def obtener_roles
    @roles = Rol.all.order('id')
  end


end
