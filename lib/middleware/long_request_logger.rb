module Middleware
  class LongRequestLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      start_time = Time.now
      status, headers, response = @app.call(env)
      end_time = Time.now
      duration = (end_time - start_time)

      if duration > 60
        request = ActionDispatch::Request.new(env)
        Rails.logger.error "Long Request Detected! Duration: #{duration.round(2)} seconds - Method: #{request.method} - Path: #{request.fullpath} - Parameters: #{request.params.inspect}"
        
        if request.method == "POST" 
          request.body.rewind
          Rails.logger.error "Request Body: #{request.body.read}"
          # Reset the body stream position to the beginning
          request.body.rewind
        end
      end

      [status, headers, response]
    end
  end
end