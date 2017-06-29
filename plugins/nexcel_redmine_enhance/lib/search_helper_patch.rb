require_dependency 'search_helper'

module SearchHelperPatch
  def self.included(base)

    base.class_eval do
      def highlight_tokens(text, tokens)
        return text unless text && tokens && !tokens.empty?
        re_tokens = tokens.collect {|t| Regexp.escape(t)}
        regexp = Regexp.new "(#{re_tokens.join('|')})", Regexp::IGNORECASE
        result = ''
        text = strip_tags(text)
        text.split(regexp).each_with_index do |words, i|
          if result.length > 1200
            # maximum length of the preview reached
            result << '...'
          break
          end
          if i.even?
            result << h(words.length > 100 ? "#{words.slice(0..44)} ... #{words.slice(-45..-1)}" : words)
          else
            t = (tokens.index(words.downcase) || 0) % 4
            result << content_tag('span', h(words), :class => "highlight token-#{t}")
          end
        end
        result.html_safe
      end
    end
  end
end

SearchHelper.send(:include, SearchHelperPatch)
