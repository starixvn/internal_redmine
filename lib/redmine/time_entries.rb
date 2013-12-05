module Redmine
  module TimeEntries

    mattr_accessor :providers

    @@providers = Hash.new {|h,k| h[k]=[] }

    class << self
      def map(&block)
        yield self
      end

      # Registers an spent time provider
      def register(event_type, options={})
        options.assert_valid_keys(:class_name, :default)

        event_type = event_type.to_s
        providers = options[:class_name] || event_type.classify
        providers = ([] << providers) unless providers.is_a?(Array)

        @@providers[event_type] += providers
      end
    end
  end
end