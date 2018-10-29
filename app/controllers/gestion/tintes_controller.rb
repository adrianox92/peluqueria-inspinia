class Gestion::TintesController < GestionController
  def index
    @tintes = Tinte.where('tipo ILIKE ?', '%tinte%').order('activo DESC')
  end

  def new
    @tinte = Tinte.new
  end

  def create
    params[:tinte][:base_compra] = params[:tinte][:precio_compra].to_f / devuelve_iva
    params[:tinte][:iva_compra] = params[:tinte][:precio_compra].to_f - params[:tinte][:base_compra]
    params[:tinte][:tipo] = 'tinte'

    tinte = Tinte.create(permit_params)
    if tinte.valid?
      redirect_to gestion_tintes_path
    else
      @tinte = tinte
      redirect_to new_gestion_tinte_path
    end
  end

  def edit
    @tinte = Tinte.find(params[:id])
  end

  def update
    tinte = Tinte.find(params[:id])
    params[:tinte][:base_compra] = params[:tinte][:precio_compra].to_f / devuelve_iva
    params[:tinte][:iva_compra] = params[:tinte][:precio_compra].to_f - params[:tinte][:base_compra]
    params[:tinte][:tipo] = 'tinte'

    if tinte.update_attributes(permit_params)
      redirect_to gestion_tintes_path
    else
      @tinte = tinte
      redirect_to edit_gestion_tinte_path tinte.id
    end
  end

  def destroy
    tinte = Tinte.find(params[:id])
    tinte.destroy
    redirect_to gestion_tintes_path
  end

  def show
    tinte = Tinte.find(params[:id])
    tinte.destroy
    redirect_to gestion_tintes_path
  end

  def permit_params
    params.require(:tinte).permit(:nombre, :precio_compra, :precio_venta, :activo, :fecha_ultima_compra, :stock, :iva_compra, :base_compra, :tipo, :codigo)
  end
end