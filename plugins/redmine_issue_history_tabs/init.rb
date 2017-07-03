require 'redmine'
require 'issue_tabs_listener.rb'

Rails.configuration.to_prepare do
  unless ActionView::Base.included_modules.include?(CustomizeJournalsHelper)
    ActionView::Base.send(:include, CustomizeJournalsHelper)
  end
end

Redmine::Plugin.register :redmine_issue_history_tabs do
  name 'Redmine Issue History Tabs plugin'
  author 'Tim'
  description 'This plugin provide history of issue in tabs representation'
  version '0.0.1'
end