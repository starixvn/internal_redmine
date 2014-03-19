require_dependency 'issue_relation'
require_dependency 'issue'

module IssueRelationPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      alias_method_chain :set_issue_to_dates, :recursive
    end
  end

  module InstanceMethods
    
    def set_issue_to_dates_with_recursive
      soonest_start = self.successor_soonest_start
      
      if soonest_start && !Setting['plugin_redmine_better_gantt_chart']['work_on_weekends']
        soonest_start += 8 - soonest_start.cwday if soonest_start.cwday >= 6
      end
      
      if soonest_start && issue_to
        issue_to.reschedule_on!(soonest_start)
        issue_to.reschedule_following_issues_with_force
      end
    end
  end
end

module IssuePatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

    end
  end

  module InstanceMethods
    # Updates start/due dates of following issues
    def reschedule_following_issues_with_force
      # if start_date_changed? || due_date_changed?
        relations_from.each do |relation|
          relation.set_issue_to_dates
        end
      # end
    end
  end  
end

IssueRelation.send(:include, IssueRelationPatch)
Issue.send(:include, IssuePatch)
