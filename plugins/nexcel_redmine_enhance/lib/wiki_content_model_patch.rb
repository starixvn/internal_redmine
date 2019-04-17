require_dependency 'wiki_content'

module WikiContentPatch
  def self.included(base)

    # base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      validates :text, length: { maximum: 5242880,
      too_long: "size must be less than 5Mb (include text and image)" }
    end

  end  
end

WikiContent.send(:include, WikiContentPatch)