require "socket"
require "yeelight_client/broadcast/broadcaster"
require "yeelight_client/broadcast/response"

class YeelightClient
  class Broadcast
    def initialize(logger: nil)
      @broadcaster = Broadcaster.new(logger: logger)
      @logger = logger
    end

    def discover
      responses = @broadcaster.broadcast
      responses.map do |response|
        Broadcast::Response.new(response)
      end
    end
  end
end

