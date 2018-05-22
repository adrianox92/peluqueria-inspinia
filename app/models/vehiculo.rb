class Vehiculo < ActiveRecord::Base
  self.table_name = 'vehiculo'

  has_many :gasolinas

end