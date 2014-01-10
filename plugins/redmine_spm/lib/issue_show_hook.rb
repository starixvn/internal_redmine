class IssueShowHook < Redmine::Hook::ViewListener
  render_on :view_issues_show_description_bottom, :partial => '/spm_widgets'    
end
