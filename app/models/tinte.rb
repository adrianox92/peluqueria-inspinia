class Tinte < ActiveRecord::Base
  self.table_name = 'producto'

  validates :nombre, :precio_compra, :stock, :fecha_ultima_compra, presence: true

  has_many :tinte_clientes

  def self.stock_bajo
    self.where('stock < ?', 3 ) #Buscamos los productos con menor stock de 10
  end
end