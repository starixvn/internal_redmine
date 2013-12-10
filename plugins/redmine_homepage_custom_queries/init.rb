
require 'redmine'
require 'welcome_page_hook'
require 'welcome_controller_patch'

Redmine::Plugin.register :redmine_homepage_custom_queries do
  name 'Redmine Homepage Custom Queries plugin'
  author 'Qui'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
