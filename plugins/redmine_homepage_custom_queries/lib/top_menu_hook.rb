class TopMenuHook < Redmine::Hook::ViewListener
  render_on :view_layouts_base_body_bottom, :partial => '/menu_queries'    
end
