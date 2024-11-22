class MessagesController < ApplicationController
  def index
    render json: Message.all
  end

  def create
    # Create a new message from the params
    message = Message.create(username: params[:username], content: params[:content])

    # Ensure we are broadcasting the message in a valid format
    ActionCable.server.broadcast 'chatroom_channel', {
      message: {
        id: message.id,
        username: message.username,
        content: message.content,
        created_at: message.created_at.strftime('%Y-%m-%d %H:%M:%S')
      }
    }
    render json: message, status: :created

    # Return a response after broadcasting
    head :ok
  end
end
