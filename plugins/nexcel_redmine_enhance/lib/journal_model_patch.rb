require_dependency 'journal'

module JournalPatch
  def self.included(base)

    # base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      validates :notes, length: { maximum: 262140,
      too_long: "must be less than 262140 characters (size < 256kb, include text and image)" }
    end
  end
end

Journal.send(:include, JournalPatch)