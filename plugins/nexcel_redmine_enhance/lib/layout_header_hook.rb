class LayoutHeaderListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context)
    addictionalTags = javascript_include_tag(:layout_enhance, :plugin => :nexcel_redmine_enhance)
    addictionalTags << stylesheet_link_tag("layout_enhance.css", :plugin => :nexcel_redmine_enhance, :media => "screen")
    addictionalTags
  end
end
