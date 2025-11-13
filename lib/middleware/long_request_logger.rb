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

      if duration > 5
        request = ActionDispatch::Request.new(env)
        
        # Extract user information
        user_info = extract_user_info(request, env)
        logTime = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        Rails.logger.error "Long Request Detected! Time: #{logTime} - Duration: #{duration.round(2)} seconds - Method: #{request.method} - Path: #{request.fullpath} - User: #{user_info} - Parameters: #{request.params.inspect}"
              
      end

      [status, headers, response]
    end

    private

    def extract_user_info(request, env)
      user_info = []
    
      # Get the current user object as identified by Redmine
      current_user = User.current 
    
      if current_user.logged?
        # If the user is logged in (session, API key, Basic Auth)
        user_info << "UserID: #{current_user.id}"
        user_info << "Username: #{current_user.login}"
        
        # Check the authentication method if needed
        if env['rack.session'] && env['rack.session'][:user_id]
          user_info << "AuthMethod: Session"
        elsif request.headers['X-Redmine-API-Key'].present? || request.params['key'].present?
          user_info << "AuthMethod: API-Key"
        elsif request.authorization.present?
          user_info << "AuthMethod: Basic-Auth"
        end
      else
        # User is a Guest
        user_info << 'Anonymous'
      end
    
      # Check for remote IP
      remote_ip = request.remote_ip || env['REMOTE_ADDR']
      user_info << "IP: #{remote_ip}" if remote_ip
    
      # Return the information string
      user_info.join(', ')
    end
  end
end