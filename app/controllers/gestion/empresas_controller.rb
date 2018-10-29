class Gestion::EmpresasController < GestionController

  def index
    @empresas = Empresa.all.order('id DESC')
  end

  def new
    @empresa = Empresa.new
  end

  def create
    empresa = Empresa.create(permit_params)

    if empresa.valid?
      redirect_to gestion_empresas_path
    else
      @empresa = empresa
      render :new
    end
  end

  def edit
    @empresa = Empresa.find(params[:id])
  end

  def update
    empresa = Empresa.find(params[:id])
    if empresa.update_attributes(permit_params)
      redirect_to gestion_empresas_path
    else
      @empresa = empresa
      redirect_to edit_gestion_empresa_path(empresa.id)
    end
  end

  def destroy
    empresa = Empresa.find(params[:id])
    empresa.destroy
    redirect_to gestion_empresas_path
  end


  def permit_params
    params.require(:empresa).permit(:iva, :comision_tarjeta, :stock_bajo, :nombre)
  end
end
