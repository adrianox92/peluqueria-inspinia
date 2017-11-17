module ApplicationHelper
    def is_active_controller(controller_name, class_name = nil)
        if params[:controller] == controller_name
         class_name == nil ? "active" : class_name
        else
           nil
        end
    end

    def is_active_action(action_name)
        params[:action] == action_name ? "active" : nil
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


end
