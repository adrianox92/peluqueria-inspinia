class Precio < ActiveRecord::Base
  self.table_name = 'precio'

  validates :nombre, :coste, presence: true

end