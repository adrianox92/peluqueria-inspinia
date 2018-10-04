class Gestion::CitasController < GestionController

  skip_before_action :verify_authenticity_token

  def index
    obtener_clientes
    obtener_citas
    @cita = Cita.new
  end

  def create
    cita = Cita.create(permit_params)
    redirect_to gestion_citas_path
  end

  def permit_params
    params.require(:cita).permit(:cliente_id, :fecha_inicio)
  end

  private

  def obtener_clientes
    @clientes = Cliente.where('activo = true').order('id').map {|c| [c.nombre_completo, c.id]}
  end

  def obtener_citas
    @citas = []
    citas = Cita.all.order('id')
    citas.each do |c|
      @citas << {:id => c.id, :title => "Cita reservada con #{Cliente.find(c.cliente_id).nombre_completo}", :start => c.fecha_inicio}
    end
    @citas = @citas.to_json
  end

end