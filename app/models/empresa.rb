class Empresa < ActiveRecord::Base
  self.table_name = 'empresa'

  validates :nombre, :iva, :comision_tarjeta, :stock_bajo, presence: true

  has_many :usuarios

end