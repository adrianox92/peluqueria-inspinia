class Cita < ActiveRecord::Base
  self.table_name = 'cita'

  has_many :clientes

end