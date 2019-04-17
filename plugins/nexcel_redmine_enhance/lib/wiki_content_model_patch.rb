require_dependency 'wiki_content'

module WikiContentPatch
  def self.included(base)

    # base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      validates :text, length: { maximum: 131072,
      too_long: "must be less than 131070 characters (size < 128kb, include text and image)" }
    end

  end  
end

WikiContent.send(:include, WikiContentPatch)