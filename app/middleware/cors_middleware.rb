class CorsMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    # Handling preflight OPTIONS request
    if env['REQUEST_METHOD'] == 'OPTIONS'
      headers = {
        'Access-Control-Allow-Origin' => 'http://localhost:5173', # Allow Vue.js from this origin
        'Access-Control-Allow-Methods' => 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD',
        'Access-Control-Allow-Headers' => 'Origin, Content-Type, Accept, Authorization',
        'Access-Control-Max-Age' => '86400',
        'Access-Control-Allow-Credentials' => 'true'
      }
      return [200, headers, []]
    elsif env['HTTP_UPGRADE'] && env['HTTP_UPGRADE'].downcase == 'websocket'
      # Handle WebSocket upgrade request
      headers = {
        'Access-Control-Allow-Origin' => 'http://localhost:5173', # Allow Vue.js from this origin
        'Access-Control-Allow-Credentials' => 'true' # Add credentials support
      }
      return @app.call(env) # Allow WebSocket connection
    else
      # Regular request, set the CORS header
      status, headers, response = @app.call(env)
      headers['Access-Control-Allow-Origin'] = 'http://localhost:5173'
      headers['Access-Control-Allow-Credentials'] = 'true'
      return [status, headers, response]
    end
  end
end
