require_dependency 'issues_helper'

module IssuesHelperPatch
  class IssueFieldsRowsCustom
    include ActionView::Helpers::TagHelper

    def initialize
      @left = []
      @right = []
    end

    def left(*args)
      args.any? ? @left << cells(*args) : @left
    end

    def right(*args)
      args.any? ? @right << cells(*args) : @right
    end

    def size
      @left.size > @right.size ? @left.size : @right.size
    end

    def to_html
      content =
        content_tag('div', @left.reduce(&:+), :class => 'splitcontentleft') +
        content_tag('div', @right.reduce(&:+), :class => 'splitcontentleft')

      content_tag('div', content, :class => 'splitcontent')
    end
  
    def cells(label, text, options={})
      options[:class] = [options[:class] || "", 'attribute'].join(' ')
      content_tag 'div',
        content_tag('div', label + ":", :class => 'label') + content_tag('div', text, :class => 'value') + content_tag('span', "", :class => options[:icon_class] || ''),
        options
    end
  end

  def self.included(base)

    base.class_eval do
      
      def render_descendants_tree(issue)
        s = '<form><table class="list issues">'
        issue_list(issue.descendants.visible.preload(:status, :priority, :tracker, :assigned_to).sort_by(&:lft)) do |child, level|
          css = "issue issue-#{child.id} hascontextmenu #{child.css_classes}"
          css << " idnt idnt-#{level}" if level > 0
          s << content_tag('tr',
             content_tag('td', check_box_tag("ids[]", child.id, false, :id => nil), :class => 'checkbox') +
             content_tag('td', link_to_issue(child, :project => (issue.project_id != child.project_id)), :class => 'subject', :style => 'width: 50%') +
             content_tag('td', h(child.status), :class => 'status') +
             content_tag('td', format_date(child.start_date)) +
             content_tag('td', format_date(child.due_date)) +
             content_tag('td', link_to_user(child.assigned_to), :class => 'assigned_to') +
             content_tag('td', child.disabled_core_fields.include?('done_ratio') ? '' : progress_bar(child.done_ratio), :class=> 'done_ratio'),
             :class => css)
        end
        s << '</table></form>'
        s.html_safe
      end

      def link_to_new_subtask(issue)
        attrs = {
          :parent_issue_id => issue,
          :category_id => h(issue.category ? issue.category.id : "-")
        }
        attrs[:tracker_id] = issue.tracker unless issue.tracker.disabled_core_fields.include?('parent_issue_id')
        link_to(l(:button_add), new_project_issue_path(issue.project, :issue => attrs))
      end
      
      def query_links(title, queries)
        return '' if queries.empty?
        # links to #index on issues/show
        content_tag('h3', title) + "\n" +
          content_tag('ul',
            queries.collect {|query|                
                if controller_name == 'gantts'
                  url_params = !(query.project_id.nil?) ? {:controller => 'gantts', :action => 'show', :project_id => @project} : {:controller => 'gantts', :action => 'show' , :project_id => nil}
                else
                  url_params = !(query.project_id.nil?) ? {:controller => 'issues', :action => 'index', :project_id => @project} : {:controller => 'issues', :action => 'index' , :project_id => nil}           
                end 
                
                css = 'query'
                css << ' selected' if query == @query
                content_tag('li', link_to(query.name, url_params.merge(:query_id => query), :class => css))
              }.join("\n").html_safe,
            :class => 'queries'
          ) + "\n"
      end
      
      def issue_fields_rows
        r = IssueFieldsRowsCustom.new
        render plain: r.to_s
        yield r
        r.to_html
      end
      
      def show_issue_status_context()
        render :plain => "showMenuContext();"
      end
    end
  end
end

IssuesHelper.send(:include, IssuesHelperPatch)