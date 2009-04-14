module LayoutHelper
  def auto_heading
    params[:controller].humanize + " – " + 
      case(params[:action])
      when 'index'
        'list'
      when 'new'
        'create'
      when 'update'
        'edit'
      when 'show'
        "#{current_object.name}"
      else
        params[:action]
      end.humanize
  end
end