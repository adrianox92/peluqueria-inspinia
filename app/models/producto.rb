class Producto < ActiveRecord::Base
  self.table_name = 'producto'

  validates :nombre, :precio_compra, :stock, :fecha_ultima_compra, presence: true

end