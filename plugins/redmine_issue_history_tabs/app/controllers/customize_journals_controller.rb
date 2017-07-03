class CustomizeJournalsController < ApplicationController
  unloadable
  
  before_filter :find_journal, :only => [:diff]
  menu_item :issues

  def diff
    @issue = @journal.issue
    if params[:detail_id].present?
      @detail = @journal.details.find_by_id(params[:detail_id])
    else
      @detail = @journal.details.detect {|d| d.prop_key == 'description'}
    end
    (render_404; return false) unless @issue && @detail
    @diff = CustomizeDiffHelper.new(@detail.value, @detail.old_value)
    @detail
  end
  
  private

  def find_journal
    @journal = Journal.visible.find(params[:id])
    @project = @journal.journalized.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end

class CustomizeDiffHelper
  include ERB::Util
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  attr_reader :diff, :words

  def initialize(content_to, content_from)
    @words = content_to.to_s.split(/(\s+)/)
    @words = @words.select {|word| word != ' '}
    words_from = content_from.to_s.split(/(\s+)/)
    words_from = words_from.select {|word| word != ' '}
    @diff = words_from.diff @words
  end

  def to_html
    words = self.words.collect{|word| word.html_safe}
    words_add = 0
    words_del = 0
    dels = 0
    del_off = 0
    diff.diffs.each do |diff|
      add_at = nil
      add_to = nil
      del_at = nil
      deleted = ""
      diff.each do |change|
        pos = change[1]
        if change[0] == "+"
          add_at = pos + dels unless add_at
          add_to = pos + dels
          words_add += 1
        else
          del_at = pos unless del_at
          deleted << ' ' unless deleted.empty?
          deleted << change[2].html_safe
          words_del  += 1
        end
      end
      if add_at
        words[add_at] = '<span class="diff_in">'.html_safe + words[add_at]
        words[add_to] = words[add_to] + '</span>'.html_safe
      end
      if del_at
        words.insert del_at - del_off + dels + words_add, '<span class="diff_out">'.html_safe + deleted.html_safe + '</span>'.html_safe
        dels += 1
        del_off += words_del
        words_del = 0
      end
    end
    words.join(' ').html_safe
  end
end
