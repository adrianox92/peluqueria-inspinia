# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cita", force: :cascade do |t|
    t.integer  "cliente_id"
    t.datetime "fecha_inicio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cliente", force: :cascade do |t|
    t.string   "nombre"
    t.string   "apellidos"
    t.string   "nombre_completo_dn"
    t.integer  "telefono"
    t.datetime "created_at"
    t.time     "updated_at"
    t.string   "sexo"
    t.boolean  "activo"
    t.datetime "ultimo_pago"
  end

  create_table "pago", force: :cascade do |t|
    t.string   "nombre"
    t.float    "pago"
    t.datetime "periodicidad"
    t.datetime "ultimo_pago"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activo",       default: true
    t.float    "base"
    t.float    "iva"
  end

  create_table "precio", force: :cascade do |t|
    t.string   "nombre"
    t.float    "coste"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activo",     default: true
  end

  create_table "producto", force: :cascade do |t|
    t.string   "nombre"
    t.float    "precio_compra"
    t.float    "precio_venta"
    t.datetime "fecha_ultima_compra"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activo",              default: true
    t.float    "base_compra"
    t.float    "iva_compra"
    t.float    "base_venta"
    t.float    "iva_venta"
    t.string   "tipo"
    t.string   "codigo"
    t.string   "color"
  end

  create_table "servicio_venta", force: :cascade do |t|
    t.integer  "venta_id"
    t.float    "precio_total"
    t.float    "base"
    t.float    "iva"
    t.integer  "servicio_id"
    t.string   "servicio_nombre_dn"
    t.integer  "producto_id"
    t.string   "precio_nombre_dn"
    t.string   "producto_nombre_dn"
    t.datetime "created_at"
  end

  create_table "usuario", force: :cascade do |t|
    t.string   "nombre"
    t.string   "clave"
    t.integer  "rol_id"
    t.datetime "created_at"
    t.datetime "last_login_at"
  end

  create_table "venta", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "precio_total"
    t.float    "base"
    t.float    "iva"
    t.string   "tipo_pago"
    t.boolean  "cerrada",          default: false
    t.string   "venta_nombre"
    t.integer  "cliente_id"
    t.float    "comision_tarjeta"
  end

  create_table "gasolina", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "precio_total"
    t.float "litros"
    t.float "precio_litro"
    t.float "kilometros"
    t.string "vehiculo"
    t.string "gasolinera"
    t.string "tipo_gasolina"
    t.datetime "fecha_repostaje"
  end

  create_table "vehiculo", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "servicio_venta", "venta", column: "venta_id", name: "venta_id_fkey"
end
