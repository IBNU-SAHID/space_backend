class CorsMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    # Handle WebSocket requests explicitly
    if websocket_request?(env)
      Rails.logger.debug "Handling WebSocket request: #{env['REQUEST_URI']}"
      return @app.call(env) # Pass WebSocket request to ActionCable
    end

    # Handle CORS for preflight OPTIONS requests
    if preflight_request?(env)
      headers = {
        'Access-Control-Allow-Origin' => 'http://localhost:5173',
        'Access-Control-Allow-Methods' => 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD',
        'Access-Control-Allow-Headers' => 'Origin, Content-Type, Accept, Authorization',
        'Access-Control-Max-Age' => '86400',
        'Access-Control-Allow-Credentials' => 'true'
      }
      return [200, headers, []] # Return 200 response for preflight
    end

    # Handle regular HTTP requests
    status, headers, response = @app.call(env)
    headers['Access-Control-Allow-Origin'] = 'http://localhost:5173'
    headers['Access-Control-Allow-Credentials'] = 'true'
    [status, headers, response]
  end

  private

  def websocket_request?(env)
    env['HTTP_UPGRADE']&.downcase == 'websocket'
  end

  def preflight_request?(env)
    env['REQUEST_METHOD'] == 'OPTIONS'
  end
end
