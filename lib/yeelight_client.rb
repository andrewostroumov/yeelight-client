require "yeelight_client/handler"
require "yeelight_client/connection"
require "yeelight_client/requests"
require "yeelight_client/response"
require "yeelight_client/response/result"
require "yeelight_client/response/exception"

class YeelightClient
  include Requests

  DEFAULT_PARAMS = {
    effect: "sudden".freeze,
    duration: 0
  }

  def initialize(addrs: nil, capabilities: {}, logger: nil)
    @logger = logger
    @connection = build_connection(addrs, capabilities)
  end

  private

  def build_connection(addrs, capabilities)
    connections = if addrs
      addrs = Array(addrs).uniq { |addr| "#{addr.ip_address}:#{addr.ip_port}".hash }

      addrs.map do |addr|
        Connection.new(host: addr.ip_address, port: addr.ip_port, logger: @logger)
      end
    else
      raise "Please specify capabilities host and port" unless capabilities[:host] && capabilities[:port]
      Connection.new(host: capabilities[:host], port: capabilities[:port], logger: @logger)
    end

    Connection::Group.new(connections: connections)
  end

  def prep_params(params)
    DEFAULT_PARAMS.merge(params)
  end
end