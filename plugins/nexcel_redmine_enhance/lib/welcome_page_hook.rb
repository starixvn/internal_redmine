class WelcomePageViewListener < Redmine::Hook::ViewListener
  def view_welcome_index_left(context)
    javascript_include_tag(:welcome, :plugin => :nexcel_redmine_enhance)
  end
end
