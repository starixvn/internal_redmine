class RedmineImprovedSearchAssigneeHookListener < Redmine::Hook::ViewListener
  render_on :view_issues_form_details_bottom, :partial => "redmine_improved_search_assignee/redmine_improved_search_assignee"
end