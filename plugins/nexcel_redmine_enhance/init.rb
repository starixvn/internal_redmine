require 'search_helper_patch'
require 'gantt_helper_patch'
require 'issues_helper_patch'
require 'gantts_controller_patch'
require 'application_helper_patch'
require 'layout_header_hook'
require 'issue_model_patch'
require 'journal_model_patch'
require 'issues_controller_patch'
require 'wiki_content_model_patch'
require 'attachments_controller_patch'
#require 'welcome_page_hook'

Redmine::Plugin.register :nexcel_redmine_enhance do
  name 'Nexcel Redmine Enhance plugin'
  author 'Raymond.Le'
  description 'This is a plugin for fix bugs and enhance in Redmine Nexdev'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  requires_redmine :version_or_higher => '3.3.3'
end
