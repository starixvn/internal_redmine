class AvatarRedirectMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    
    redmine_root = Rails.root.to_s
    file_path = File.join(redmine_root, "avatars", "default.jpg")

    if request.path.match(%r{^/images/avatars/.*\.jpg$})
      if File.exist?(file_path)
        response_body = File.binread(file_path)
        return [200, { 'Content-Type' => 'image/jpeg' }, [response_body]]
      else
    file_path = File.join(redmine_root, "avatars", "default.jpg")
        return [404, { 'Content-Type' => 'text/plain' }, ["Default avatar not found:" + file_path]]
      end
    else
      @app.call(env)
    end
  end
end
