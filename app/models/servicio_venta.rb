class ServicioVenta < ActiveRecord::Base
  self.table_name = 'servicio_venta'

  belongs_to :venta
  belongs_to :precio

end