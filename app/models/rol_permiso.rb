class RolPermiso < ActiveRecord::Base
  self.table_name = 'rol_permiso'

  belongs_to :rol
  belongs_to :permiso

end