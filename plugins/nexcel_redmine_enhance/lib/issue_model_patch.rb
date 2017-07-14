require_dependency 'issue'

module IssuePatch
  def self.included(base)

    # base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      validates :description, length: { maximum: 65535,
      too_long: "must be less than 65535 characters (size < 64kb, include text and image)" }
    end

  end  
end

Issue.send(:include, IssuePatch)