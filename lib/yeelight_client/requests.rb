class YeelightClient
  module Requests
    extend Handler

    def get_prop(props: nil)
      props = prep_props(props || PROPERTIES)

      query = {
        method: "get_prop",
        params: props
      }

      responses = @connection.request(query)
      responses.map { |response| Response::Properties.new(props, response) }
    end

    def set_bright(value, params: {})
      params = prep_params(params)
        .slice(:effect, :duration)

      query = {
        method: "set_bright",
        params: [value, *params.values]
      }

      responses = @connection.request(query)
      responses.map { |response| Response::Result.new(response) }
    end

    def set_rgb(value, params: {})
      params = prep_params(params)
        .slice(:effect, :duration)

      query = {
        method: "set_rgb",
        params: [value, *params.values]
      }

      responses = @connection.request(query)
      responses.map { |response| Response::Result.new(response) }
    end

    instance_methods.each { |method| wrap(method) }
  end
end