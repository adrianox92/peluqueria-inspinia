class Gestion::PagosController < GestionController
  def index
    @pagos = Pago.all.order('activo DESC')
  end

  def new
    @pago = Pago.new
  end

  def create
    pago = Pago.create(permit_params)
    if pago.valid?
      redirect_to gestion_pagos_path
    else
      @pago = pago
      redirect_to new_gestion_pago_path
    end
  end

  def edit
    @pago = Pago.find(params[:id])
  end

  def update
    pago = Pago.find(params[:id])
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

  def permit_params
    params.require(:pago).permit(:nombre, :pago, :periodicidad, :ultimo_pago, :activo)
  end
end