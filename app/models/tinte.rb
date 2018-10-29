class Tinte < ActiveRecord::Base
  self.table_name = 'producto'

  validates :nombre, :precio_compra, :stock, :fecha_ultima_compra, presence: true

  has_many :tinte_clientes

  def self.stock_bajo(stock_bajo)
    self.where('stock < ?', stock_bajo ) #Buscamos los productos con menor stock de 10
  end
end