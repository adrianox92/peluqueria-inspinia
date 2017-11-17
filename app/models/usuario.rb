class Usuario < ActiveRecord::Base
  self.table_name = 'usuario'

  has_many :roles
end