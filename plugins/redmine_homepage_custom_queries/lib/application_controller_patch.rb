require_dependency 'application_controller'
require_dependency 'issues_helper'

ApplicationController.send(:helper, IssuesHelper)