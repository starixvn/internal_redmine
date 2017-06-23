require 'redmine'
require 'spent_time_form_hook'
require 'spent_time_patch'

Redmine::Plugin.register :redmine_save_spent_time_queries do
  name 'Redmine Save Spent Time Queries plugin'
  author 'Qui'
  description 'This plugin allows to save spent time queries'
  version '0.1.0'
  url 'http://www.redmine.org/plugins/redmine_save_spent_time_queries'
  author_url 'http://www.redmine.org/plugins/redmine_save_spent_time_queries'
    
  menu :top_menu, :spent_time_query, { :controller => 'spent_time_query', :action => 'index' }, :caption => :label_header_spent_times

end
