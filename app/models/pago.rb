class Pago < ActiveRecord::Base
  self.table_name = 'pago'

  validates :nombre, :pago, presence: true

end