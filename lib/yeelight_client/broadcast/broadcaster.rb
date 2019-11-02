class YeelightClient
  class Broadcast
    class Broadcaster
      DEFAULT_TIMEOUT = 3
      DEFAULT_MAX_PACK = 65_535
      HEADER_MATCH = /^([^:]+):\s*(.+)$/

      SSDP_HOST = "239.255.255.250".freeze
      SSDP_PORT = 1982
      SSDP_MX = 100
      SSDP_ST = "wifi_bulb".freeze

      def initialize(logger: nil)
        @socket = create_socket
        @logger = logger
      end

      def broadcast
        query = build_query
        @socket.send(query, 0, SSDP_HOST, SSDP_PORT)
        packages = receive
        packages.map { |message, producer| process_packet(message, producer) }
      end

      private

      def receive
        remaining = DEFAULT_TIMEOUT
        responses = []

        while remaining > 0
          start_time = Time.now
          ready = IO.select([@socket], nil, nil, remaining)

          @logger&.info { "Receive #{ready.dig(0, 0).inspect}" } if ready

          if ready
            message, producer = @socket.recvfrom DEFAULT_MAX_PACK
            responses << [message, producer]
          end

          remaining -= (Time.now - start_time).to_i
        end

        responses
      end

      def process_packet(message, producer)
        message = parse_message(message)
        { address: producer[3], port: producer[1], message: message }
      end

      def parse_message(message)
        message.gsub! "\r\n", "\n"
        header, body = message.split "\n\n"

        header = header.split "\n"
        status = header.shift
        params = {}
        header.each do |line|
          match = HEADER_MATCH.match line
          next if match.nil?
          value = match[2]
          value = (value[1, value.length - 2] || '') if value.start_with?('"') && value.end_with?('"')
          params[match[1]] = value
        end

        { status: status, headers: params, body: body }
      end

      def build_query
        query = "M-SEARCH * HTTP/1.1\r\n" \
              "HOST: #{SSDP_HOST}:#{SSDP_PORT}\r\n" \
              "MAN: \"ssdp:discover\"\r\n" \
              "MX: #{SSDP_MX}\r\n" \
              "ST: #{SSDP_ST}\r\n" \
              "\r\n"
        query
      end

      def create_socket
        broadcaster = UDPSocket.new
        broadcaster.setsockopt Socket::SOL_SOCKET, Socket::SO_BROADCAST, true
        broadcaster.setsockopt Socket::IPPROTO_IP, Socket::IP_MULTICAST_TTL, 1
        broadcaster
      end
    end
  end
end
