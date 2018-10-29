# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Empresa.find_or_create_by(nombre: 'Peluqueria Mar Sanz') do |usuario|
  usuario.iva = 21
  usuario.comision_tarjeta = 10
  usuario.stock_bajo = 10
end

Usuario.find_or_create_by(nombre: 'administrador') do |usuario|
  usuario.clave = Digest::MD5.hexdigest('administrador')
  usuario.rol_id = 1
  usuario.empresa_id = 1
end