require 'redmine'
require 'issue_show_hook'

Redmine::Plugin.register :redmine_spm do
  name 'Redmine Spm plugin'
  author 'Qui'
  description 'Support edit stored procedures belong to an issue'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
