class TinteCliente < ActiveRecord::Base
  self.table_name = 'tinte_cliente'

  belongs_to :cliente
  belongs_to :tinte

end