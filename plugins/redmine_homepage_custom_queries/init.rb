require 'redmine'
require 'welcome_page_hook'
require 'top_menu_hook'
require 'application_controller_patch'

Redmine::Plugin.register :redmine_homepage_custom_queries do
  name 'Redmine Homepage Custom Queries plugin'
  author 'Qui'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  menu :top_menu, :issues, {:controller => 'issues', :action => 'index', :project_id => nil}, :caption => 'Issues'
  menu :top_menu, :custom_queries_menu, {:controller => 'issues', :action => 'index', :project_id => nil}, :caption => 'Custom queries'
  menu :top_menu, :my_queries_menu, {:controller => 'issues', :action => 'index', :project_id => nil}, :caption => 'My queries'  
  
end
