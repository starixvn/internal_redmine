class McHumanResourceMgmtProjectController < ApplicationController
  unloadable

  layout 'base'
  before_filter :find_project, :authorize
  menu_item :redmine_monitoring_controlling
  
  def index    
    #tool instance
    tool = McTools.new
    
    #get main project
    @project = Project.find_by_identifier(params[:id])

    #get projects and sub projects
    stringSqlProjectsSubProjects = tool.return_ids(@project.id)    
    
    @fixed_versions = Version.find_all_by_project_id(@project.id)    
    
    filter_versions = params[:versions] == nil ? Array.new : params[:versions].map { |x| x.to_i }
    if filter_versions.count == 0
      filter_versions = @fixed_versions.map { |x| x.id };   
      @selected_versions = Array.new 
    else
      @selected_versions = filter_versions
    end
    
    filter_versions.push("null")
    filter_versions_s = (filter_versions * ",") + ",null"  
    
    # total issues from the project and subprojects
    if filter_versions.count == 1
      @totalIssues = Issue.where(:project_id => [stringSqlProjectsSubProjects]).count
    else
      @totalIssues = Issue.where(:project_id => [stringSqlProjectsSubProjects], :fixed_version_id => filter_versions).count
    end
    
    @statusesByAssigneds = Issue.find_by_sql("select assigned_to_id, (select firstname from users where id = assigned_to_id) as assigned_first_name, (select lastname from users where id = assigned_to_id) as assigned_last_name,
                                              issue_statuses.id, issue_statuses.name, 
                                         	    (select COUNT(1) 
                                               from issues i 
                                               where i.project_id in (#{stringSqlProjectsSubProjects})
                                               and (fixed_version_id in (#{filter_versions_s}) or fixed_version_id is null)
                                               and ((i.assigned_to_id = issues.assigned_to_id and i.assigned_to_id is not null)or(i.assigned_to_id is null and issues.assigned_to_id is null)) and i.status_id = issue_statuses.id) as totalassignedbystatuses
                                               from issues, issue_statuses  
                                               where project_id in (#{stringSqlProjectsSubProjects}) 
                                               and (fixed_version_id in (#{filter_versions_s}) or fixed_version_id is null)
                                               group by assigned_to_id, assigned_first_name, assigned_last_name, issue_statuses.id, issue_statuses.name
                                               order by 2,3;")  || nil  
  end

  private
  def find_project
    @project=Project.find(params[:id])
  end


end