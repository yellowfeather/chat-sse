class EventsController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'

    sse = SSE.new(response.stream, retry: 300, event: "message")
    channel = 'chat-sse-channel'

    redis = Redis.new(url: ENV['REDISTOGO_URL'])
    redis.subscribe(channel) do |on|
      on.message do |channel, message|
        logger.info "EventsController.index sse.write"
        sse.write(message, id: Time.now)
      end
    end
  rescue IOError
    logger.info "EventsController.index Stream closed"
  ensure
    logger.info "EventsController.index closing"
    redis.quit
    sse.close
  end
end
