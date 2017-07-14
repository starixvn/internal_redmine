require_dependency 'wiki_content'

module WikiContentPatch
  def self.included(base)

    # base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      validates :text, length: { maximum: 65535,
      too_long: "must be less than 65535 characters (size < 64kb, include text and image)" }
    end

  end  
end

WikiContent.send(:include, WikiContentPatch)