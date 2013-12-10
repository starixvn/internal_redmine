class WelcomePageHook < Redmine::Hook::ViewListener
  render_on :view_welcome_index_right, :partial => '/queries'    
end
