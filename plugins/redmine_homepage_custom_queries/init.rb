require 'redmine'
require 'welcome_page_hook'
require 'top_menu_hook'
require 'application_controller_patch'

Redmine::Plugin.register :redmine_homepage_custom_queries do
  name 'Redmine Homepage Custom Queries plugin'
  author 'Qui & Forrest'
  description 'This plugin allow to show custom queries on top menu'
  version '0.0.2'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  menu :top_menu, :issues, {:controller => 'issues', :action => 'index', :project_id => nil, :set_filter => 1 }, :caption => 'Issues'
  menu :top_menu, :custom_queries_menu, {:controller => 'issues', :action => 'index', :project_id => nil}, :caption => 'Custom queries'
  menu :top_menu, :my_queries_menu, {:controller => 'issues', :action => 'index', :project_id => nil}, :caption => 'My queries'  
  
end