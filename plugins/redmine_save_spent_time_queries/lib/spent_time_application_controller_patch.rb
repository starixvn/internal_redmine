require_dependency 'application_controller'
require_dependency 'timelog_helper'

module SpentTimeQueryHelper
  
  def spent_time_queries
    @queries = SpentTimeQuery.where("user_id = ? OR is_public = ?", User.current.id, true)
    @queries
  end  
  
end

module TimelogHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      alias_method_chain :format_criteria_value, :add_issue_description
    end    
    
  end

  module InstanceMethods
    def format_criteria_value_with_add_issue_description(criteria_options, value)
      if value.blank?
        "[#{l(:label_none)}]"
      elsif k = criteria_options[:klass]
        obj = k.find_by_id(value.to_i)
        if obj.is_a?(Issue)
          obj.visible? ? 
            # "#{obj.tracker} ##{obj.id}: #{obj.subject} <div class='issue_short_description'>Start date: <b>#{obj.start_date}</b>, Due date: <b>#{obj.due_date}</b>, Est. time: <b>#{obj.estimated_hours}</b></div>" 
            "#{obj.tracker} ##{obj.id} (#{obj.start_date} => #{obj.due_date} ~#{obj.estimated_hours}): #{obj.subject}"
             : 
             "##{obj.id}"
        else
          obj
        end
      else
        format_value(value, criteria_options[:format])
      end
    end 
    
  end
end


ApplicationController.send(:helper, SpentTimeQueryHelper)
TimelogHelper.send(:include, TimelogHelperPatch)