require "socket"
require "json"
require "timeout"

class YeelightClient
  class Connection
    class Group
      def initialize(connections:)
        @connections = Array(connections)
      end

      def request(query)
        @connections.map { |connection| connection.request(query) }
      end
    end

    DEFAULT_TIMEOUT = 60
    DEFAULT_REQUEST_ID = 0
    DEFAULT_PORT = 5544

    def initialize(host:, port: nil, logger: nil)
      @host = host
      @port = port || DEFAULT_PORT
      @logger = logger
      # TODO: shared counter
      @request_id = rand(10) * 1000 + DEFAULT_REQUEST_ID
    end

    def request(query)
      request_id = build_request_id
      query = { id: request_id }.merge(query)

      @logger&.info { "Query #{query.to_json} to yeelight #{@host}:#{@port}" }
      text = dump_query(query)

      socket = TCPSocket.new(@host, @port)
      socket.write(text)

      result = Timeout.timeout(DEFAULT_TIMEOUT) do
        loop do
          data = socket.readline
          result = parse_data(data)
          break result if result["id"].eql?(@request_id)
        end
      end

      @logger&.info { "Result #{result.to_json}" }
      result

    ensure
      socket&.close
    end

    private

    def dump_query(query)
      "#{query.to_json}\r\n"
    end

    def parse_data(data)
      JSON.parse(data)
    end

    def build_request_id
      @request_id += 1
    end
  end
end
