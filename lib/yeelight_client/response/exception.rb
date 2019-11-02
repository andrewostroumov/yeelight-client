class YeelightClient
  class Response
    class Exception < YeelightClient::Response
      attr_reader :exception

      def initialize(exception)
        @exception = exception
        detect_errors
      end

      def success?
        false
      end

      def data
        {}
      end

      def details
        @exception.message
      end

      private

      def detect_errors
        # EOFError - when lamp is busy
        case @exception
        when EOFError
          assign_errors(:device_busy, :device_error)
        when Timeout::Error, Errno::ETIMEDOUT
          assign_errors(:http_timeout, :network_error)
        when Errno::ECONNRESET, Errno::ECONNREFUSED, Errno::EINVAL
          assign_errors(:socket_error, :network_error)
        else
          assign_errors(:unknown, :exception)
        end
      end
    end
  end
end
