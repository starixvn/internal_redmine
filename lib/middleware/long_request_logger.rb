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

      if duration > 30
        request = ActionDispatch::Request.new(env)
        
        # Extract user information
        user_info = extract_user_info(request, env)
        
        Rails.logger.error "Long Request Detected! Duration: #{duration.round(2)} seconds - Method: #{request.method} - Path: #{request.fullpath} - User: #{user_info} - Parameters: #{request.params.inspect}"
              
      end

      [status, headers, response]
    end

    private

    def extract_user_info(request, env)
      user_info = []

      # Try to get user from session
      if env['rack.session'] && env['rack.session'][:user_id]
        user_id = env['rack.session'][:user_id]
        user_info << "UserID: #{user_id}"
        
        # Try to get username if User model is available
        begin
          user = User.find_by_id(user_id)
          user_info << "Username: #{user.login}" if user
        rescue => e
          # Skip if User model is not available or error occurs
        end
      end

      # Check for API token in headers
      api_key = request.headers['X-Redmine-API-Key'] || request.params['key']
      if api_key.present?
        user_info << "API-Token: #{api_key[0..7]}***" # Show only first 8 chars for security
        
        # Try to get user from token
        begin
          token = Token.find_by_value(api_key)
          if token && token.user
            user_info << "TokenUser: #{token.user.login}"
          end
        rescue => e
          # Skip if Token model is not available or error occurs
        end
      end

      # Check for basic authentication
      if request.authorization.present?
        auth_type = request.authorization.split(' ').first
        user_info << "Auth: #{auth_type}"
      end

      # Check for remote IP
      remote_ip = request.remote_ip || env['REMOTE_ADDR']
      user_info << "IP: #{remote_ip}" if remote_ip

      user_info.empty? ? 'Anonymous' : user_info.join(', ')
    end
  end
end