require_dependency 'welcome_controller'
require_dependency 'issues_helper'

WelcomeController.send(:helper, IssuesHelper)