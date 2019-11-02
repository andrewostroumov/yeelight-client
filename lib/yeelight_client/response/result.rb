class YeelightClient
  class Response
    class Result < YeelightClient::Response
      def data
        return {} unless success?
        @data["result"]
      end

      def detect_errors
        return if success?
        message = @data.dig("error", "message")

        case message
        when /client quota exceeded/i
          assign_errors(:request_quota, :device_error)
        when /general error/i
          assign_errors(:bad_request, :bad_input)
        else
          super
        end
      end
    end
  end
end