class YeelightClient
  class Response
    class Result < YeelightClient::Response
      def data
        return unless success?
        super["result"]
      end

      # {"id"=>4, "error"=>{"code"=>-5000, "message"=>"general error"}}
      # Result {"id":8232,"error":{"code":-1,"message":"client quota exceeded"}}
      def detect_errors
        return unless success?

      end
    end
  end
end