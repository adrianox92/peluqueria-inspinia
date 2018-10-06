class Gestion::RolesController < GestionController

  def index
    @models = []
    ActiveRecord::Base.connection.tables.map do |model|
      @models << model.capitalize.gsub("_", ' ')
    end
  end
end
