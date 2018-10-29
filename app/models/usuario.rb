class Usuario < ActiveRecord::Base
  self.table_name = 'usuario'

  has_many :role
  belongs_to :empresa
end