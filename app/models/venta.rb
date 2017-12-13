class Venta < ActiveRecord::Base
  self.table_name = 'venta'

  has_many :servicio_ventas
  belongs_to :cliente
end
