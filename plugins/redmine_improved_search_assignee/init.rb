require 'redmine'
require_dependency 'redmine_improved_search_assignee_hook_listener'

Redmine::Plugin.register :redmine_improved_search_assignee do
  name 'Redmine Improved Search Assignee plugin'
  author 'Tim'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end
