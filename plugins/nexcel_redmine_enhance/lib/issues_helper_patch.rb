require_dependency 'issues_helper'

module IssuesHelperPatch
  def self.included(base)

    base.class_eval do
      include CustomizeApplicationHelper
      
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
    end
  end
end

module CustomizeApplicationHelper

  def customize_textilizable(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    case args.size
    when 1
      obj = options[:object]
      text = args.shift
    when 2
      obj = args.shift
      attr = args.shift
      text = obj.send(attr).to_s
    else
      raise ArgumentError, 'invalid arguments to textilizable'
    end
    return '' if text.blank?
    project = options[:project] || @project || (obj && obj.respond_to?(:project) ? obj.project : nil)
    @only_path = only_path = options.delete(:only_path) == false ? false : true

    text = text.dup
    macros = catch_macros(text)
    #text = Redmine::WikiFormatting.to_html(Setting.text_formatting, text, :object => obj, :attribute => attr)

    @parsed_headings = []
    @heading_anchors = {}
    @current_section = 0 if options[:edit_section_links]

    parse_sections(text, project, obj, attr, only_path, options)
    text = parse_non_pre_blocks(text, obj, macros) do |text|
      [:parse_inline_attachments, :parse_wiki_links, :parse_redmine_links].each do |method_name|
        send method_name, text, project, obj, attr, only_path, options
      end
    end
    parse_headings(text, project, obj, attr, only_path, options)

    if @parsed_headings.any?
      replace_toc(text, @parsed_headings)
    end

    text.html_safe
  end

end

IssuesHelper.send(:include, IssuesHelperPatch)

