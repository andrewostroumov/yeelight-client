class YeelightClient
  class Response
    attr_reader :error, :error_type

    def initialize(data)
      @data = data
      detect_errors
    end

    def success?
      @data&.has_key?("result")
    end

    def fail?
      !success?
    end

    def data
      @data || {}
    end

    def details

    end

    private

    def detect_errors
      return if success?
      assign_errors(:unknown, :unknown)
    end

    def assign_errors(error, type)
      @error = error
      @error_type = type
    end
  end
end
