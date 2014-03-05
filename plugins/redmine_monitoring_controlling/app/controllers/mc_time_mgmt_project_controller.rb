class McTimeMgmtProjectController < ApplicationController
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
    filter_versions_s = (filter_versions * ",")

    # total issues from the project and subprojects
    if filter_versions.count == 1
      @totalIssues = Issue.where(:project_id => [stringSqlProjectsSubProjects]).count
    else
      @totalIssues = Issue.where(:project_id => [stringSqlProjectsSubProjects], :fixed_version_id => filter_versions).count
    end

    @issuesSpentHours = Issue.find_by_sql("select issues.due_date, sum(issues.estimated_hours) as estimated_hours,
                                                  (select sum(i.estimated_hours)
                                                  from issues i
                                                  where i.project_id in (#{stringSqlProjectsSubProjects})
                                                  and (fixed_version_id in (#{filter_versions_s}) or fixed_version_id is null)
                                                  /*and i.due_date is not null*/
                                                  and i.due_date <= issues.due_date and i.parent_id is null) as sumestimatedhours,
                                                  (select sum(hours) from time_entries where project_id in (#{stringSqlProjectsSubProjects}) and spent_on <= issues.due_date ) as sumspenthours
                                                  from issues
                                                  where issues.project_id in (#{stringSqlProjectsSubProjects})
                                            /*and due_date is not null*/
                                            and (fixed_version_id in (#{filter_versions_s}) or fixed_version_id is null)
                                            and due_date <= issues.due_date
                                            and parent_id is null
                                            group by issues.due_date
                                            order by due_date;")
                                        

    @spentHoursByVersion = Issue.find_by_sql("select versions.name as version, versions.effective_date, sum(issues.estimated_hours) as estimated_hours, 
                                             (select sum(i.estimated_hours) 
                                              from issues i
                                              where i.project_id in (#{stringSqlProjectsSubProjects})
                                              and i.fixed_version_id = versions.id
                                              /*and i.due_date is not null*/
                                              and i.parent_id is null 
                                              and i.due_date <= versions.effective_date) as sumestimatedhours,
                                             (select sum(hours) 
                                              from issues i, time_entries t
                                              where i.project_id in (#{stringSqlProjectsSubProjects})
                                              and i.project_id = t.project_id
                                              and i.id = t.issue_id
                                              and i.fixed_version_id = versions.id
                                              and t.spent_on <= versions.effective_date) as sumspenthours
                                             from issues, versions 
                                             where issues.project_id in (#{stringSqlProjectsSubProjects})
                                             and issues.parent_id is null
                                             and issues.fixed_version_id = versions.id
                                             and due_date <= versions.effective_date
                                             group by versions.id, versions.name, versions.effective_date
                                             order by versions.effective_date;")
                                      

  end

  private
  def find_project
    @project=Project.find(params[:id])
  end


end
