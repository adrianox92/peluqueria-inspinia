class Rol < ActiveRecord::Base
  self.table_name = 'rol'

  has_many :usuarios
  has_many :rol_permisos

end