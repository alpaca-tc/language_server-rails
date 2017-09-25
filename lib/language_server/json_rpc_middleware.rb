# frozen_string_literal: true

require 'rack'
require 'rack/request'

module LanguageServer
  class JsonRPCMiddleware
    REQUEST_BODY = 'language_server.request_body'

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      begin
        parse_body(request)
      rescue JSONError
        return [500, {}, { code: '-32700' }]
      end

      begin
        _status, headers, body = @app.call(env)
        [200, headers, body]
        # rescue InvalidRequest
        #   return [400, {}, { code: '-32600' }]
        # rescue MethodNotFound
        #   return [404, {}, { code: '-32601' }]
        # rescue InvalidParams
        #   return [500, {}, { code: '-32602' }]
        # rescue
        #   return [500, {}, { code: '-32603' }]
        # rescue Exception => error
        #   return [500, {}, { code: '-32099' }]
      end
    end

    private

    def parse_body(request)
      rack_input = request.get_header(Rack::RACK_INPUT)
      json = JSON.parse(rack_input.read, symbolize_names: true)
      request.set_header(REQUEST_BODY, json)
    ensure
      rack_input.rewind
    end
  end
end
