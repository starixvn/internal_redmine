require_dependency 'gantts_controller'
require_relative './helpers/custom_lib_redmine_helpers'

module GanttsControllerPatch
  def self.included(base)

    base.class_eval do
      def show
        @gantt = CustomRedmineHelpers::Gantt.new(params)
        @gantt.project = @project
        retrieve_query
        @query.group_by = nil
        @gantt.query = @query if @query.valid?

        basename = (@project ? "#{@project.identifier}-" : '') + 'gantt'

        respond_to do |format|
          format.html { render :action => "show", :layout => !request.xhr? }
          format.png  { send_data(@gantt.to_image, :disposition => 'inline', :type => 'image/png', :filename => "#{basename}.png") } if @gantt.respond_to?('to_image')
          format.pdf  { send_data(@gantt.to_pdf, :type => 'application/pdf', :filename => "#{basename}.pdf") }
        end
      end

    end
  end
end


GanttsController.send(:include, GanttsControllerPatch)