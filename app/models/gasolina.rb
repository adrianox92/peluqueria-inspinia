class Gasolina < ActiveRecord::Base
  self.table_name = 'gasolina'

  validates :precio_total, :litros, :precio_litro, :vehiculo, :gasolinera, presence: true

end