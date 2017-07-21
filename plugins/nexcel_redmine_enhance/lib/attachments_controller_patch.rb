require_dependency 'attachments_controller'

module AttachmentsControllerPatch
  def self.included(base)

    base.class_eval do
      def disposition(attachment)
        if attachment.is_pdf? || attachment.image?
          'inline'
        else
          'attachment'
        end
      end
    end
    
  end
end

AttachmentsController.send(:include, AttachmentsControllerPatch)
