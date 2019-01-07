class Gestion::CitasController < GestionController

  skip_before_action :verify_authenticity_token

  def index
    obtener_clientes
    obtener_citas
    @cita = Cita.new
    @cliente = Cliente.new
    @horas = [['30 minutos', 30],['1 hora',60],['1 hora y media', 90], ['2 horas', 120]]
  end

  def create
    if params[:cita][:cliente_id].blank? #Si me viene vacío quiere decir que creo un nuevo cliente
      params[:cliente][:nombre_completo_dn] = "#{params[:cliente][:nombre]} #{params[:cliente][:apellidos]}"
      params[:cliente][:activo] = true
      cliente = Cliente.create(permit_params_cliente)
      params[:cita][:cliente_id] = cliente.id
    end
    a = 0
    fecha_inicio = Date.strptime(params[:cita][:fecha_inicio], '%Y-%m-%d %H:%M')
    hora_inicio = DateTime.strptime(params[:cita][:fecha_inicio], '%Y-%m-%d %H:%M').to_s(:time)
    hora_fin = (DateTime.strptime("#{fecha_inicio} #{hora_inicio}", '%Y-%m-%d %H:%M').to_time + (params[:cita][:fecha_fin].to_i.minutes)) - 2.hour
    fecha_fin = DateTime.strptime("#{hora_fin}", '%Y-%m-%d %H:%M:%S')
    params[:cita][:fecha_fin] = fecha_fin
    cita = Cita.create(permit_params)
    redirect_to gestion_citas_path
  end

  def permit_params
    params.require(:cita).permit(:cliente_id, :fecha_inicio, :fecha_fin)
  end

  def permit_params_cliente
    params.require(:cliente).permit(:nombre, :apellidos, :sexo, :telefono, :activo, :nombre_completo_dn)
  end


  private

  def obtener_clientes
    @clientes = Cliente.where('activo = true').order('id').map {|c| [c.nombre_completo, c.id]}
  end

  def obtener_citas
    @citas = []
    citas = Cita.all.order('id')
    citas.each do |c|
      @citas << {:id => c.id, :title => "Cita reservada con #{Cliente.find(c.cliente_id).nombre_completo}", :start => c.fecha_inicio, :end => c.fecha_fin, color:"##{(Cliente.find(c.cliente_id).sexo == "Hombre") ? "4682B4" : "DB7093" }"}
    end
    @citas = @citas.to_json
  end

end