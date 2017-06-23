module Acl::Patches::Models
  module CustomFieldValuePatch
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        alias_method_chain :value_was, :acl
        alias_method_chain :value, :acl
        alias_method_chain :value=, :acl

        attr_accessor :acl_changed, :acl_value
      end
    end

    module InstanceMethods
      def value_with_acl
        return value_without_acl if @value_init

        @value_init = true
        if self.customized.present?
          if self.custom_field.multiple?
            values = self.customized.custom_values.select { |v| v.custom_field == self.custom_field }
            if values.empty?
              values << self.customized.custom_values.build(customized: self.customized, custom_field: self.custom_field)
            end
            @acl_value = {}
            vl = []
            values.each do |p|
              @acl_value[p.value] = p.id
              vl << p.value
            end
          else
            cv = self.customized.custom_values.detect { |v| v.custom_field == self.custom_field }
            cv ||= self.customized.custom_values.build(customized: self.customized, custom_field: self.custom_field)
            @acl_value = { cv.value => cv.id }
            vl = cv.value
          end
          self.value_was = vl.dup if vl
          @value = vl
        end

        value_without_acl
      end

      def value_was_with_acl
        return value_was_without_acl if @value_init

        self.value
        value_was_without_acl
      end

      def value_with_acl=(vl)
        self.value unless @value_init
        send :value_without_acl=, vl
      end
    end
  end
end