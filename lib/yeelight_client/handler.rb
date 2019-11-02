class YeelightClient
  module Handler
    def wrap(method)
      prev = "_#{method}".to_sym
      alias_method prev, method
      define_method(method) do |*args|
        begin
          responses = send(prev, *args)
          return responses if responses.size > 1
          responses.first
        rescue => exception
          Response::Exception.new(exception)
        end
      end
    end
  end
end