class Gestion::ClientesController < GestionController

  skip_before_action :verify_authenticity_token

  def index
    @clientes = find_clientes

  end

  def new
    fill_form
    @cliente = Cliente.new
  end

  def create
    params[:cliente][:nombre_completo_dn] = "#{params[:cliente][:nombre]} #{params[:cliente][:apellidos]}"
    cliente = Cliente.create(permit_params)

    if cliente.valid?
      redirect_to gestion_clientes_path
    else
      @cliente = cliente
      fill_form
      render :new
    end
  end

  def edit
    fill_form
    @cliente = Cliente.find(params[:id])
  end

  def update
    cliente = Cliente.find(params[:id])
    params[:cliente][:nombre_completo_dn] = "#{params[:cliente][:nombre]} #{params[:cliente][:apellidos]}"

    if cliente.update_attributes(permit_params)
      redirect_to gestion_clientes_path
    else
      @cliente = cliente
      redirect_to edit_gestion_cliente_path cliente.id
    end
  end


  def fill_form
    @sexo = [['Hombre', 'Hombre'], ['Mujer', 'Mujer']]
  end

  def find_clientes
    clientes = Cliente.order('created_at DESC')
    if session[:filter_cliente_nombre].present?
      clientes = clientes.where('nombre_completo_dn ILIKE ?', "%#{session[:filter_cliente_nombre]}%")
    end
    clientes
  end

  def filtrar_clientes
    session[:filter_cliente_nombre] = params[:cliente_nombre] if params[:cliente_nombre].present?
    redirect_to gestion_clientes_path
  end

  def resetear_filtros
    session.delete(:filter_cliente_nombre)
    redirect_to gestion_clientes_path
  end

  def permit_params
    params.require(:cliente).permit(:nombre, :apellidos, :sexo, :telefono, :activo, :nombre_completo_dn)
  end

end