module Redmine
  module TimeEntries
    # Class used to retrieve spent time entries
    class Fetcher
      attr_reader :total_hours, :query, :entries, :scope

      include SortHelper
      include TimelogHelper
      include CustomFieldsHelper
      include QueriesHelper

      # Returns an array of entries for the given date range
      # sorted in reverse chronological order
      def initialize(user)        
        @user = user        
      end

      def all(params)
       
       # "f"=>["spent_on", "user_id", ""], "op"=>{"spent_on"=>"lm", "user_id"=>"="}, "v"=>{"user_id"=>["91"]}, "c"=>["project", "spent_on", "activity", "issue", "comments", "hours"]
       
        query = TimeEntryQuery.build_from_params(params, :name => '_')
        @scope = time_entry_scope(query)
                    
        @entries = @scope.all(
          :include => [:project, :activity, {:issue => :tracker}],
          :limit  =>  100,
          :offset =>  0,
          :order => "#{TimeEntry.table_name}.created_on DESC",
        )
        
        @total_hours = @scope.sum(:hours).to_f

        query
      end
      
      # Returns the TimeEntry scope for index and report actions
      def time_entry_scope(query)
        @scope = TimeEntry.visible.where(query.statement)
        @scope
      end

    end
  end
end