class MessagesController < ApplicationController
  def create
    channel = 'chat-sse-channel'
    message = Rack::Utils.escape_html(params["message"])
    $redis.publish(channel, {sender: params["sender"], message: message}.to_json)
    head :ok
  end
end
