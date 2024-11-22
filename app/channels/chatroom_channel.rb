class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chatroom_channel"
    Rails.logger.info "User subscribed to ChatroomChannel"
  end

  def receive(data)
    Rails.logger.info "Received data: #{data}"
    ActionCable.server.broadcast("chatroom_channel", message: data["message"])

  end

  def unsubscribed
    logger.info "Client unsubscribed from ChatroomChannel"
  end

end
