class LayoutHeaderListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context)
    javascript_include_tag(:layout_enhance, :plugin => :nexcel_redmine_enhance)
    # byebug
    # stylesheet_link_tag("layout_enhance.css", :plugin => :nexcel_redmine_enhance)
  end
end
