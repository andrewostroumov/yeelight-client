class YeelightClient
  class Response
    class Properties < YeelightClient::Response::Result
      def initialize(*args)
        @props = args[0]
        super(*args[1..-1])
      end

      def data
        return {} unless success?
        result = @data["result"]
        array = @props.map.with_index { |prop, i| [prop, result[i]] }
        Hash[array]
      end
    end
  end
end