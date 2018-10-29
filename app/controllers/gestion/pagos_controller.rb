class Gestion::PagosController < GestionController
  def index
    @pagos = Pago.all.order('activo DESC')
  end

  def new
    fill_form
    @pago = Pago.new
  end

  def create
    params[:pago][:base] = params[:pago][:pago].to_f / devuelve_iva
    params[:pago][:iva] = params[:pago][:pago].to_f - params[:pago][:base]

    pago = Pago.create(permit_params)

    if pago.valid?
      redirect_to gestion_pagos_path
    else
      @pago = pago
      fill_form
      render :new
    end
  end

  def edit
    fill_form
    @pago = Pago.find(params[:id])
  end

  def update
    pago = Pago.find(params[:id])
    params[:pago][:base] = params[:pago][:pago].to_f / devuelve_iva
    params[:pago][:iva] = params[:pago][:pago].to_f - params[:pago][:base]
    if pago.update_attributes(permit_params)
      redirect_to gestion_pagos_path
    else
      @pago = pago
      redirect_to edit_gestion_pago_path pago.id
    end
  end

  def destroy
    pago = Pago.find(params[:id])
    pago.destroy
    redirect_to gestion_pagos_path
  end

  def show
    pago = Pago.find(params[:id])
    pago.destroy
    redirect_to gestion_pagos_path
  end

  def fill_form
    @periodicidad =[['Semanal', 'Semanal'], ['Quincenal', 'Quincenal'], ['Mensual', 'Mensual'], ['Bimensual', 'Bimensual'], ['Trimestal', 'Trimestal'], ['Medio Año', 'Medio Año'], ['Anual', 'Anual'], ['Puntual', 'Puntual']]
  end

  def permit_params
    params.require(:pago).permit(:nombre, :pago, :periodicidad, :ultimo_pago, :activo, :base, :iva)
  end
end