class EventsController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'

    sse = SSE.new(response.stream, retry: 300, event: "message")
    channel = 'chat-sse-channel'

    redis = Redis.new(url: ENV['REDISTOGO_URL'])
    redis.subscribe(channel) do |on|
      on.message do |channel, message|
        sse.write(message, id: Time.now)
      end
    end
  rescue IOError
    logger.info "Stream closed"
  ensure
    redis.quit
    sse.close
  end
end
