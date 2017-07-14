require_dependency 'application_controller'
require_dependency 'issues_controller'
require_dependency '../lib/redmine/pagination'

module IssuesControllerPatch
  def self.included(base)
    include Redmine::Pagination

    base.class_eval do
      def index
        retrieve_query

        @is_short_by_parent = params['sort_by_parent'] == '1'
        if @is_short_by_parent && params[:sort].nil?
          params[:sort] = "parent:desc"
        end

        sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
        sort_update(@query.sortable_columns)
        @query.sort_criteria = sort_criteria.to_a

        if @query.valid?
          case params[:format]
          when 'csv', 'pdf'
            @limit = Setting.issues_export_limit.to_i
            if params[:columns] == 'all'
              @query.column_names = @query.available_inline_columns.map(&:name)
            end
          when 'atom'
            @limit = Setting.feeds_limit.to_i
          when 'xml', 'json'
            @offset, @limit = api_offset_and_limit
            @query.column_names = %w(author)
          else
          @limit = per_page_option
          end

          @issue_count = @query.issue_count
          @issue_pages = Paginator.new @issue_count, @limit, params['page']
          @offset ||= @issue_pages.offset
          @issues = @query.issues(:include => [:assigned_to, :tracker, :priority, :category, :fixed_version],
                              :order => sort_clause,
                              :offset => @offset,
                              :limit => @limit)
          @issue_count_by_group = @query.issue_count_by_group

          respond_to do |format|
            format.html { render :template => 'issues/index', :layout => !request.xhr? }
            format.api  {
              Issue.load_visible_relations(@issues) if include_in_api_response?('relations')
            }
            format.atom { render_feed(@issues, :title => "#{@project || Setting.app_title}: #{l(:label_issue_plural)}") }
            format.csv  { send_data(query_to_csv(@issues, @query, params[:csv]), :type => 'text/csv; header=present', :filename => 'issues.csv') }
            format.pdf  { send_file_headers! :type => 'application/pdf', :filename => 'issues.pdf' }
          end
        else
          respond_to do |format|
            format.html { render(:template => 'issues/index', :layout => !request.xhr?) }
            format.any(:atom, :csv, :pdf) { render(:nothing => true) }
            format.api { render_validation_errors(@query) }
          end
        end
      rescue ActiveRecord::RecordNotFound
        render_404
     end

      def update
        return unless update_issue_from_params

        #00000 - Return error if notes attr invalid
        unless @issue.current_journal.valid?
          errors_flash = @issue.current_journal.errors.full_messages.join("</br>")
          flash.now[:error] = errors_flash.html_safe
          respond_to do |format|
            format.html { render :action => 'edit' }
          end
          
          return
        end

        @issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))

        saved = false
        begin
          saved = save_issue_with_child_records
        rescue ActiveRecord::StaleObjectError
          @conflict = true
          if params[:last_journal_id]
            @conflict_journals = @issue.journals_after(params[:last_journal_id]).to_a
            @conflict_journals.reject!(&:private_notes?) unless User.current.allowed_to?(:view_private_notes, @issue.project)
          end
        end

        if saved
          render_attachment_warning_if_needed(@issue)
          flash[:notice] = l(:notice_successful_update) unless @issue.current_journal.new_record?

          respond_to do |format|
            format.html { redirect_back_or_default issue_path(@issue, previous_and_next_issue_ids_params) }
            format.api  { render_api_ok }
          end
        else
          respond_to do |format|
            format.html { render :action => 'edit' }
            format.api  { render_validation_errors(@issue) }
          end
        end
      end
    end

  end
end

IssuesController.send(:include, IssuesControllerPatch)
