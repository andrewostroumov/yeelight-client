class YeelightClient
  class Broadcast
    class Response
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def addr
        location = @data.dig(:message, :headers, "Location")
        return unless location
        uri = URI.parse(location)
        Addrinfo.tcp(uri.host, uri.port)
      end
    end
  end
end
