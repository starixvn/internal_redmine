require_dependency 'issue'

module IssuePatch
  def self.included(base)

    # base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      validates :description, length: { maximum: 131070,
      too_long: "must be less than 131070 characters (size < 128kb, include text and image)" }
    end

  end  
end

Issue.send(:include, IssuePatch)