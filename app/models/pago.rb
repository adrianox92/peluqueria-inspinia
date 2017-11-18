class Pago < ActiveRecord::Base
  self.table_name = 'pago'

  validates :nombre, :pago, :periodicidad, presence: true

end