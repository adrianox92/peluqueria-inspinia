class Gestion::UsuariosController < GestionController

  def index
    @usuarios = obtener_usuarios
  end

  def new

  end

  def edit

  end

  def create

  end

  def update

  end

  private

  def obtener_usuarios
    Usuario.where('activo = ?', true).order('id')
  end


end
