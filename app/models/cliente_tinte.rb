class ClienteTinte < ActiveRecord::Base
  self.table_name = 'cliente_tinte'

  belongs_to :cliente
  belongs_to :tinte

end