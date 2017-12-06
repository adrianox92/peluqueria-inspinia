class Cliente < ActiveRecord::Base
  self.table_name = 'cliente'

  validates :nombre, :apellidos, presence: true

  validates :telefono, :numericality => true,
            :length => { :minimum => 9, :maximum => 14 }

  def self.filter(filter)
    if filter
      where(nombre_completo_dn: filter)
    end
  end

end