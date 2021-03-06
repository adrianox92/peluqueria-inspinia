class Cliente < ActiveRecord::Base
  self.table_name = 'cliente'

  has_many :ventas

  validates :nombre, :apellidos, presence: true

  validates :telefono, :numericality => true,
            :length => { :minimum => 9, :maximum => 14 }

  def self.filter(filter)
    if filter
      where(nombre_completo_dn: filter)
    end
  end

  #Concatenamos el nombre del cliente y sus apellidos
  def nombre_completo
    "#{self.nombre} #{self.apellidos}"
  end

end