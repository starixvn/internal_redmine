require 'issues_controller_patch' 

Redmine::Plugin.register :redmine_issues_custom_sort do
  name 'Redmine Issues Custom Sort plugin'
  author 'Raymond.Le'
  description 'This is a plugin for add custom sort by parent task in issues list'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

