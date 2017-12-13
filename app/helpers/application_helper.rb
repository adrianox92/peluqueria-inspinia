module ApplicationHelper
  def is_active_controller(controller_name, class_name = nil)
    if params[:controller] == controller_name
      class_name == nil ? "active" : class_name
    else
      nil
    end
  end

  def is_active_action(action_name)
    controller_name == action_name ? "active" : nil
  end

  #Transforma un booleano de la BBDD a un icono de FontAwesome
  # @return HTML
  def boolean_to_human (campo)
    out = ''
    if campo
      out = '<i class="fa fa-check activo"></i>'
    else
      out = '<i class="fa fa-times inactivo"></i>'
    end
    out
  end

  def genre_to_human (genero)
    out = ''
    if genero == 'Mujer'
      out = '<i data-toggle="tooltip" data-placement="top" title="" data-original-title="Mujer" class="fa fa-female mujer"></i>'
    else
      out = '<i data-toggle="tooltip" data-placement="top" title="" data-original-title="Hombre" class="fa fa-male hombre"></i>'
    end
    out
  end

  def field_class(resource, field_name)
    if resource.errors[field_name] and not resource.errors[field_name].empty?
      return "error".html_safe
    else
      return "".html_safe
    end
  end

  def fecha_legible(fecha)
    fecha.strftime("%d/%m/%Y")
  end


end
