class Precio < ActiveRecord::Base
  self.table_name = 'precio'

  validates :nombre, :coste, :activo, presence: true

end