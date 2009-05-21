module LayoutHelper
  def auto_heading
    klass = params[:controller].humanize
    case(params[:action])
    when 'index'
      klass
    when 'new'
      "create #{klass.singularize}"
    when 'update'
      "#{current_object.name} - edit"
    when 'show'
      "#{current_object.name} (#{klass})"
    else
      params[:action]
    end.titleize
  end
  
  def space
    '&nbsp;'
  end
end